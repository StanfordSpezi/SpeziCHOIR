//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OpenAPIRuntime
import OpenAPIURLSession
import ResearchKitSwiftUI
import SpeziCHOIR
import SwiftUI


extension CHOIRQuestions {
    @MainActor
    @Observable
    class ViewModel {
        var surveyToken: String?
        var assessmentStep: Components.Schemas.AssessmentStep?
        var stepProgress: Double = 0
        var loading: Bool = true
        var showHandlingOnboardingAlert: Bool = false
        var showAssessmentContinueAlert: Bool = false
        var attributedTitle1: AttributedString?
        var attributedTitle2: AttributedString?
        var managedFormResult = ResearchFormResult()
        var continueButtonEnabled = false
        var scrollPosition = ScrollPosition(edge: .top)
        var errorMessage: String?
        
        
        func handleAssessmentStepChange(_ newStep: Components.Schemas.AssessmentStep?) {
            if let progress = newStep?.displayStatus.progress {
                self.stepProgress = progress
            }
            
            scrollPosition.scrollTo(edge: .top)
            
            if let title1 = newStep?.question.value1?.title1 {
                do {
                    let attributed = try AttributedString.html(withBody: title1)
                    attributedTitle1 = attributed
                } catch {
                    print(error)
                    attributedTitle1 = AttributedString("Title cannot be rendered.")
                }
            }
            if let title2 = newStep?.question.value1?.title2 {
                do {
                    let attributed = try AttributedString.html(withBody: title2)
                    attributedTitle2 = attributed
                } catch {
                    print(error)
                    attributedTitle2 = AttributedString("Title cannot be rendered.")
                }
            } else {
                attributedTitle2 = nil
            }
        }
        
        func handleInitialQuestionLoading(choir: CHOIRModuleProtocol, surveySite: String) async {
            do {
                loading = true
    
                if let surveyToken = UserDefaults.standard.string(forKey: "survey-token") {
                    let assessmentStepData = try await start(choir: choir, surveySite: surveySite, token: surveyToken)
                    handleAssessmentStepChange(assessmentStepData)
                    loading = false
                } else {
                    let onboardingData = try await onboarding(choir: choir, surveySite: surveySite)
                    if let surveyToken = onboardingData.displayStatus.surveyToken {
                        let surveyTokenString = String(surveyToken)
                        self.surveyToken = surveyTokenString
                        UserDefaults.standard.set(surveyTokenString, forKey: "survey-token")
                    }
                    
                    let questionPayload = Components.Schemas.AssessmentStep.questionPayload(value1: onboardingData.question)
                    let assessmentStep = Components.Schemas.AssessmentStep(displayStatus: onboardingData.displayStatus, question: questionPayload)
                    self.assessmentStep = assessmentStep
                    
                    handleAssessmentStepChange(assessmentStep)
                    loading = false
                }
            } catch let error as CHOIRError {
                errorMessage = error.localizedDescription
                showHandlingOnboardingAlert = true
                loading = false
            } catch {
                errorMessage = "An unknown error occurred."
                showHandlingOnboardingAlert = true
                loading = false
            }
        }
        
        private func onboarding(choir: CHOIRModuleProtocol, surveySite: String) async throws -> Components.Schemas.Onboarding {
            let onboardingData = try await choir.onboarding(site: surveySite)
            return onboardingData
        }
        
        private func start(choir: CHOIRModuleProtocol, surveySite: String, token: String) async throws -> Components.Schemas.AssessmentStep {
            let assessmentStepData = try await choir.startAssessmentStep(site: surveySite, token: token)
            return assessmentStepData
        }
        
        func assessmentContinue(
            choir: CHOIRModuleProtocol,
            surveySite: String,
            token: String,
            results: ResearchFormResult,
            backRequest: Bool
        ) async {
            do {
                loading = true
                let transformedResults = results.compactMap {
                    Components.Schemas.FormFieldAnswer(fieldId: $0.identifier, choice: $0.answer.mapToStringArray())
                }
                let formAnswer = Components.Schemas.FormAnswer(fieldAnswers: transformedResults)
                let answers = Components.Schemas.AssessmentSubmit.answersPayload(value1: formAnswer)
                let submitStatus: Components.Schemas.SubmitStatus? =
                if let assessmentStep {
                    Components.Schemas.SubmitStatus(
                        questionId: assessmentStep.displayStatus.questionId,
                        questionType: Components.Schemas.SubmitStatus.questionTypePayload.form,
                        stepNumber: Double(assessmentStep.displayStatus.stepNumber ?? "0") ?? 0,
                        surveySectionId: assessmentStep.displayStatus.surveySectionId,
                        sessionToken: assessmentStep.displayStatus.sessionToken,
                        locale: assessmentStep.displayStatus.locale,
                        backRequest: backRequest
                    )
                } else {
                    nil
                }
                let assessmentSubmit = Components.Schemas.AssessmentSubmit(submitStatus: submitStatus, answers: answers)
                let body = Operations.postAssessmentStep.Input.Body.json(assessmentSubmit)
                let response = try await choir.continueAssessmentStep(site: surveySite, token: token, body: body)
                assessmentStep = response
                handleAssessmentStepChange(assessmentStep)
                loading = false
            } catch let error as CHOIRError {
                errorMessage = error.localizedDescription
                showAssessmentContinueAlert = true
                loading = false
            } catch {
                errorMessage = "An unknown error occurred."
                showHandlingOnboardingAlert = true
                loading = false
            }
        }
    }
}


extension AnswerFormat {
    func mapToStringArray() -> [String] {
        func mapValue<T>(_ value: T?) -> String {
            if let value = value {
                return String(describing: value)
            }
            return ""
        }
        
        switch self {
        case .text(let text):
            return [text ?? ""]
        case .date(let date):
            return [date.map { DateFormatter().string(from: $0) } ?? ""]
        case .height(let height):
            return [mapValue(height)]
        case .weight(let weight):
            return [mapValue(weight)]
        case .numeric(let numeric):
            return [mapValue(numeric)]
        case .scale(let scale):
            return [mapValue(scale)]
        case .multipleChoice(let results):
            return results?.map { $0.mapToString() } ?? []
        default:
            return []
        }
    }
}

extension ResultValue {
    func mapToString() -> String {
        switch self {
        case .string(let str):
            return str
        case .date(let date):
            return DateFormatter().string(from: date)
        case .int(let int):
            return String(int)
        }
    }
}
