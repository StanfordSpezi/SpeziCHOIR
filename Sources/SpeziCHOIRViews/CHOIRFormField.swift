//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKitSwiftUI
import SpeziCHOIR
import SwiftUI


struct CHOIRFormField: View {
    let formField: Components.Schemas.FormField?
    @State private var attributedLabel: AttributedString?
    
    
    var body: some View {
        // swiftlint:disable:next closure_body_length
        Group {
            switch formField?._type {
            case .number:
                VStack {
                    if let attributedLabel = attributedLabel {
                        Text(attributedLabel)
                            .padding(.horizontal)
                    }
                    NumericQuestion(
                        id: formField?.fieldId ?? "",
                        title: "",
                        detail: "",
                        prompt: ""
                    )
                        .questionRequired(formField?.required ?? false)
                }
            case .textArea:
                TextQuestion(
                    id: formField?.fieldId ?? "",
                    header: {
                        if let attributedLabel = attributedLabel {
                            Text(attributedLabel)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    },
                    prompt: "",
                    lineLimit: .multiline,
                    characterLimit: formField?.max.flatMap { Int($0) } ?? 250
                )
                    .questionRequired(formField?.required ?? false)
            case .checkboxes:
                VStack {
                    if let attributedLabel = attributedLabel {
                        Text(attributedLabel)
                            .padding(.horizontal)
                    }
                    MultipleChoiceQuestion(
                        id: formField?.fieldId ?? "",
                        title: "",
                        choices: formField?.values?.map { TextChoice(id: $0.id, choiceText: $0.label, value: $0.id) } ?? [],
                        choiceSelectionLimit: .multiple
                    )
                        .questionRequired(formField?.required ?? false)
                }
            case .radios:
                VStack {
                    if let attributedLabel = attributedLabel {
                        Text(attributedLabel)
                            .padding(.horizontal)
                    }
                    MultipleChoiceQuestion(
                        id: formField?.fieldId ?? "",
                        title: "",
                        choices: formField?.values?.map { TextChoice(id: $0.id, choiceText: $0.label, value: $0.id) } ?? [],
                        choiceSelectionLimit: .single
                    )
                        .questionRequired(formField?.required ?? false)
                }
            case .heading:
                Text(attributedLabel ?? "")
                    .padding([.horizontal, .top])
                    .frame(maxWidth: .infinity, alignment: .leading)
            case .text:
                TextQuestion(
                    id: formField?.fieldId ?? "",
                    header: {
                        if let attributedLabel = attributedLabel {
                            Text(attributedLabel)
                                .padding()
                        }
                    },
                    prompt: "",
                    lineLimit: .singleLine,
                    characterLimit: formField?.max.flatMap { Int($0) } ?? 100
                )
                    .accessibility(identifier: formField?.fieldId ?? "")
                    .questionRequired(formField?.required ?? false)
            case .datePicker:
                DateTimeQuestion(
                    id: formField?.fieldId ?? "",
                    title: formField?.label ?? "",
                    pickerPrompt: "",
                    displayedComponents: .date,
                    range: Date.distantPast...Date.distantFuture
                )
                    .questionRequired(formField?.required ?? false)
            case .dropdown:
                VStack {
                    if let attributedLabel = attributedLabel {
                        Text(attributedLabel)
                            .padding(.horizontal)
                    }
                    MultipleChoiceQuestion(
                        id: formField?.fieldId ?? "",
                        title: "",
                        choices: formField?.values?.map {
                            TextChoice(id: $0.id, choiceText: $0.label, value: $0.id)
                        } ?? [],
                        choiceSelectionLimit: .single
                    )
                        .questionRequired(formField?.required ?? false)
                }
            default:
                Text("Unsupported Question Type.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
            .onAppear {
                if let label = formField?.label {
                    do {
                        attributedLabel = try AttributedString.html(withBody: label)
                    } catch {
                        attributedLabel = "Unkown Label"
                    }
                }
            }
    }
}
