//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import Spezi
import SpeziAccount


/// A service that provides a real network connection to the CHOIR API.
public class CHOIRService: Module {
    public static let valueConfiguration: AccountValueConfiguration = [
        .requires(\.userId),
        .supports(\.name),
        .supports(\.phoneNumber)
    ]
    
    internal let client: Client
    
    // periphery:ignore - false positive
    /// Initializes a new CHOIR module instance.
    /// - Parameter serverURL: The URL of the CHOIR server.
    public init(serverURL: URL) {
        self.client = Client(
            serverURL: serverURL,
            transport: URLSessionTransport(),
            middlewares: [FirebaseAuthMiddleware()]
        )
    }
    
    /// Initially loads the assessment step and the survey token for subsequent steps needed in `continueAssessmentStep`.
    /// - Parameter site: The survey site.
    /// - Returns: The onboarding response.
    @MainActor
    public func onboarding(site: String) async throws -> Components.Schemas.Onboarding {
        let onboardingData = try await client.getOnboarding(path: .init(site: site), headers: .init(accept: [.init(contentType: .json)]))
        switch onboardingData {
        case .ok:
            return try onboardingData.ok.body.json
        case .internalServerError(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.internalServerError(message: errorMessage)
        case .badRequest(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.badRequest(message: errorMessage)
        case .unauthorized(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.unauthorized(message: errorMessage)
        default:
            throw CHOIRError.unknown
        }
    }
    
    /// Initially loads the assessment step for subsequent steps needed in `continueAssessmentStep`.
    /// - Parameters:
    ///   - site: The survey site.
    ///   - token: The survey token.
    /// - Returns: The onboarding response.
    @MainActor
    public func startAssessmentStep(site: String, token: String) async throws -> Components.Schemas.AssessmentStep {
        let assessmentStepData = try await client.getAssessment(
            path: .init(site: site, surveyToken: token),
            headers: .init(accept: [.init(contentType: .json)])
        )
        switch assessmentStepData {
        case .ok:
            return try assessmentStepData.ok.body.json
        case .internalServerError(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.internalServerError(message: errorMessage)
        case .badRequest(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.badRequest(message: errorMessage)
        case .notFound(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.notFound(message: errorMessage)
        case .unauthorized(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.unauthorized(message: errorMessage)
        default:
            throw CHOIRError.unknown
        }
    }
    
    /// Continues to the next assessment step.
    /// - Parameters:
    ///   - site: The survey site.
    ///   - token: The survey token.
    ///   - body: The body of the assessment step.
    /// - Returns: The assessment step response.
    @MainActor
    public func continueAssessmentStep(
        site: String,
        token: String,
        body: Operations.postAssessmentStep.Input.Body
    ) async throws -> Components.Schemas.AssessmentStep {
        let assessmentStepData = try await client.postAssessmentStep(
            path: .init(site: site, surveyToken: token),
            headers: .init(accept: [.init(contentType: .json)]),
            body: body
        )
        switch assessmentStepData {
        case .ok:
            return try assessmentStepData.ok.body.json
        case .internalServerError(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.internalServerError(message: errorMessage)
        case .badRequest(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.badRequest(message: errorMessage)
        case .notFound(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.notFound(message: errorMessage)
        case .unauthorized(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.unauthorized(message: errorMessage)
        default:
            throw CHOIRError.unknown
        }
    }
    
    @MainActor
    func convertToString(httpBody: OpenAPIRuntime.HTTPBody) async -> String {
        do {
            return try await String(collecting: httpBody, upTo: .max)
        } catch {
            return "Unkown error."
        }
    }
}


/// A module for interacting with the CHOIR API.
public class CHOIRModule: Module, EnvironmentAccessible {
    public let choirService: CHOIRService
    
    public init(service: CHOIRService) {
        self.choirService = service
    }
}


/// A mock implementation of the `CHOIRService`.
/// 
/// This module returns predefined mock data with a simulated network latency to help test CHOIR API integrations
/// without requiring a connection to the actual server.
public final class CHOIRMockService: CHOIRService {
    private var onboardingQuestion: Components.Schemas.Onboarding?
    private var questionStack = [Components.Schemas.AssessmentStep]()
    
    /// Initializes a new mock module instance.
    public init() {
        // swiftlint:disable:next force_unwrapping
        super.init(serverURL: URL(string: "https://mock.example.com")!)
        onboardingQuestion = decodeOnboardingQuestion()
        questionStack = decodeQuestions()
    }
    
    private func decodeQuestions() -> [Components.Schemas.AssessmentStep] {
        let mockDataFiles = Bundle.module.urls(forResourcesWithExtension: "json", subdirectory: "Questions") ?? []
        let jsonStrings = mockDataFiles.compactMap { try? String(contentsOf: $0, encoding: .utf8) }
        
        return jsonStrings.compactMap { jsonString in
            guard let jsonData = jsonString.data(using: .utf8) else {
                return nil
            }
            do {
                return try JSONDecoder().decode(Components.Schemas.AssessmentStep.self, from: jsonData)
            } catch {
                print("Error decoding JSON:", error)
                return nil
            }
        }
    }
    
    private func decodeOnboardingQuestion() -> Components.Schemas.Onboarding? {
        guard let mockDataFile = Bundle.module.url(
            forResource: "onboardingStep",
            withExtension: "json"
        ) else {
            print("Error: Could not locate onboardingStep.json in MockData directory")
            return nil
        }
        let jsonString = try? String(contentsOf: mockDataFile, encoding: .utf8)
        guard let jsonData = jsonString?.data(using: .utf8) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(Components.Schemas.Onboarding.self, from: jsonData)
        } catch {
            print("Error decoding JSON:", error)
            return nil
        }
    }
    
    /// Simulates the start of an onboarding process.
    /// - Parameter site: The survey site.
    /// - Returns: A mock onboarding response.
    @MainActor
    override public func onboarding(site: String) async throws -> Components.Schemas.Onboarding {
        if let question = onboardingQuestion {
            let onboardingData = try Operations.getOnboarding.Output.Ok(
                body: Operations.getOnboarding.Output.Ok.Body.json(question)
            ).body.json
            try await Task.sleep(for: .milliseconds(300)) // simulate 300ms network latency
            return onboardingData
        } else {
            throw CHOIRError.internalServerError(message: "No more questions.")
        }
    }
    
    /// Simulates the loading of the first or left off assessment step.
    /// - Parameters:
    ///   - site: The survey site.
    ///   - token: The survey token.
    /// - Returns: A mock assessment step response.
    @MainActor
    override public func startAssessmentStep(site: String, token: String) async throws -> Components.Schemas.AssessmentStep {
        if let question = questionStack.popLast() {
            let assessmentStepData = try Operations.getAssessment.Output.Ok(
                body: Operations.getAssessment.Output.Ok.Body.json(question)
            ).body.json
            try await Task.sleep(for: .milliseconds(300)) // simulate 300ms network latency
            return assessmentStepData
        } else {
            throw CHOIRError.internalServerError(message: "No more questions.")
        }
    }
    
    /// Simulates the continuation of an assessment step.
    /// - Parameters:
    ///   - site: The survey site.
    ///   - token: The survey token.
    ///   - body: The body of the assessment step.
    /// - Returns: A mock assessment step response.
    @MainActor
    override public func continueAssessmentStep(
        site: String,
        token: String,
        body: Operations.postAssessmentStep.Input.Body
    ) async throws -> Components.Schemas.AssessmentStep {
        if let question = questionStack.popLast() {
            let assessmentStepData = try Operations.postAssessmentStep.Output.Ok(
                body: Operations.postAssessmentStep.Output.Ok.Body.json(question)
            ).body.json
            try await Task.sleep(for: .milliseconds(300)) // simulate 300ms network latency
            return assessmentStepData
        } else {
            throw CHOIRError.internalServerError(message: "No more questions.")
        }
    }
}
