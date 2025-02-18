//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziCHOIR
import SpeziCHOIRViews
import SwiftUI


struct QuestionView: View {
    @State var openSheet = true
    
    
    var body: some View {
        Text("Home")
            .sheet(isPresented: $openSheet) {
                CHOIRQuestions(onFinish: { openSheet.toggle() }, surveySite: "")
            }
    }
}

#Preview {
    QuestionView()
}
