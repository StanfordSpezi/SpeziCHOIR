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
import SpeziFoundation
import SpeziViews
import SwiftUI


/// A SwiftUI view that displays CHOIR survey questions and handles user responses.
/// 
/// The `CHOIRQuestions` view manages the display and submission of CHOIR survey questions, including:
/// - Progress tracking through the survey
/// - Question rendering based on type (form, radio buttons, etc.)
/// - Navigation between questions
/// - Error handling and retry logic
/// - Survey completion
public struct CHOIRQuestions: View {
    @Environment(\.choirModule) var choir
    @Environment(\.dismiss) var dismiss
    
    var surveySite: String
    var onFinish: () -> Void
    
    @State private var viewModel = ViewModel()
    
    
    public var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: viewModel.stepProgress, total: Constants.maxCHOIRProgress)
                .progressViewStyle(.linear)
                .animation(.easeInOut, value: viewModel.stepProgress)
            CHOIRStep(
                question: viewModel.assessmentStep?.question.value1,
                scrollPosition: $viewModel.scrollPosition,
                loading: $viewModel.loading,
                continueButtonEnabled: $viewModel.continueButtonEnabled,
                attributedTitle1: $viewModel.attributedTitle1,
                attributedTitle2: $viewModel.attributedTitle2
            )
                .processingOverlay(isProcessing: viewModel.loading) {
                    skeletonView
                }
                .environmentObject(viewModel.managedFormResult)
            continueButtonView
        }
            .padding(.horizontal)
            .background(Color(UIColor.systemGroupedBackground))
            .task {
                await viewModel.handleInitialQuestionLoading(choir: choir, surveySite: surveySite)
            }
            .alert("Failed to load question. \(viewModel.errorMessage ?? "Unknown error.")", isPresented: $viewModel.showHandlingOnboardingAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
                Button("Try Again") {
                    Task {
                        await viewModel.handleInitialQuestionLoading(choir: choir, surveySite: surveySite)
                    }
                }
            }
            .alert("Failed to load question. \(viewModel.errorMessage ?? "Unknown error.")", isPresented: $viewModel.showAssessmentContinueAlert) {
                Button("OK", role: .cancel) {}
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    navigationTitleView
                }
            }
            .navigationBarBackButtonHidden()
            .onChange(of: viewModel.managedFormResult) {
                print("managedFormResult changed: \(viewModel.managedFormResult)")
            }
    }
    
    
    private var navigationTitleView: some View {
        VStack {
            if let pageTitle = viewModel.assessmentStep?.displayStatus.pageTitle, !pageTitle.isEmpty {
                Text(pageTitle)
                    .font(.headline)
            } else {
                Text("Placeholder")
                    .font(.headline)
                    .redacted(reason: .placeholder)
                    .shimmer()
            }
        }
    }
    
    private var continueButtonView: some View {
        VStack {
            if let terminal = viewModel.assessmentStep?.question.value1?.terminal, terminal {
                Button {
                    onFinish()
                } label: {
                    Text("Finish")
                        .frame(maxWidth: .infinity, minHeight: 38)
                }
                    .buttonStyle(.borderedProminent)
            } else {
                AsyncButton {
                    if let surveyToken = viewModel.surveyToken {
                        await viewModel.assessmentContinue(
                            choir: choir,
                            surveySite: surveySite,
                            token: surveyToken,
                            results: viewModel.managedFormResult,
                            backRequest: false
                        )
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity, minHeight: 38)
                }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.continueButtonEnabled || viewModel.loading)
            }
        }
    }
    
    private var skeletonView: some View {
        VStack {
            SkeletonCell()
                .skeletonLoading(replicationCount: 5, spacing: 16)
            Spacer()
        }
            .padding(.vertical)
    }
    
    public init(onFinish: @escaping () -> Void, surveySite: String) {
        self.onFinish = onFinish
        self.surveySite = surveySite
    }
}


#if DEBUG
#Preview {
    CHOIRQuestions(onFinish: {}, surveySite: "")
        .previewWith {
            CHOIRMockModule()
        }
}
#endif
