//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKitSwiftUI
import SpeziCHOIR
import SpeziFoundation
import SwiftUI


struct CHOIRStep: View {
    var question: Components.Schemas.FormQuestion?
    @Binding var scrollPosition: ScrollPosition
    @Binding var loading: Bool
    @Binding var continueButtonEnabled: Bool
    @Binding var attributedTitle1: AttributedString?
    @Binding var attributedTitle2: AttributedString?
 
    
    var body: some View {
        if let question = question {
            ScrollView {
                ResearchFormStep {
                    stepHeader()
                } content: {
                    buildFields(for: question)
                }
                    .padding(.vertical)
                    .onPreferenceChange(StepCompletedPreferenceKey.self) { stepCompleted in
                        runOrScheduleOnMainActor {
                            continueButtonEnabled = stepCompleted
                        }
                    }
                    .scrollTargetLayout()
            }
                .scrollPosition($scrollPosition)
        } else {
            Text("No question available.")
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    @ViewBuilder
    private func buildFields(for question: Components.Schemas.FormQuestion) -> some View {
        if let fields = question.fields {
            ForEach(fields, id: \.fieldId) { field in
                CHOIRFormField(formField: field)
            }
        }
    }
    
    private func stepHeader() -> some View {
        VStack {
            if let attributedTitle1 = attributedTitle1 {
                Text(attributedTitle1)
                    .padding()
                    .foregroundStyle(Color.choice(for: .label))
            }
            if let attributedTitle2 = attributedTitle2 {
                Text(attributedTitle2)
                    .padding()
                    .foregroundStyle(Color.choice(for: .label))
            }
        }
            .frame(maxWidth: .infinity)
            .background(.cardColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
    }
}


#if DEBUG
#Preview {
    let question = Components.Schemas.FormQuestion(
        title1: "Test",
        title2: "Test",
        fields: [.init(fieldId: "test", _type: .heading, label: "Test")]
    )
    var attributedTitle1: AttributedString?
    var attributedTitle2: AttributedString?
    
    
    CHOIRStep(
        question: question,
        scrollPosition: .constant(.init(edge: .top)),
        loading: .constant(false),
        continueButtonEnabled: .constant(false),
        attributedTitle1: .constant(attributedTitle1),
        attributedTitle2: .constant(attributedTitle2)
    )
        .background(Color(UIColor.systemGroupedBackground))
        .task {
            do {
                attributedTitle1 = try AttributedString.html(withBody: question.title1)
            } catch {
                attributedTitle1 = AttributedString("Title cannot be rendered.")
            }
            do {
                if let title2 = question.title2 {
                    attributedTitle2 = try AttributedString.html(withBody: title2)
                }
            } catch {
                 attributedTitle2 = AttributedString("Title cannot be rendered.")
            }
        }
}
#endif
