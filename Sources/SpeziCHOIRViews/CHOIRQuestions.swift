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
import SpeziOnboarding
import SpeziViews
import SwiftUI


/// todo docs
public struct CHOIRQuestions: View {
    @Environment(\.choirModule) var choir
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = ViewModel()
    var surveySite: String
    var onFinish : () -> ()
    
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
                .environmentObject(viewModel.managedFormResult)
                .processingOverlay(isProcessing: viewModel.loading) {
                    skeletonView
                }
            continueButtonView
        }
            .padding(.horizontal)
            .background(Color(UIColor.systemGroupedBackground))
            .task {
                await viewModel.handleOnboarding(choir: choir, surveySite: surveySite)
            }
            .alert("Failed to load question. \(viewModel.errorMessage ?? "Unknown error.")", isPresented: $viewModel.showHandlingOnboardingAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
                Button("Try Again") {
                    Task {
                        await viewModel.handleOnboarding(choir: choir, surveySite: surveySite)
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
    }
    
    
    public init(onFinish: @escaping () -> Void, surveySite: String) {
        self.onFinish = onFinish
        self.surveySite = surveySite
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
}


#if DEBUG
#Preview {
    CHOIRQuestions(onFinish: {}, surveySite: "")
        .previewWith {
            CHOIRMockModule()
        }
}
#endif
