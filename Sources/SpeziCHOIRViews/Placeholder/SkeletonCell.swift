//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKitSwiftUI
import SpeziCHOIR
import SpeziViews
import SwiftUI


struct SkeletonCell: View {
    @State private var managedFormResult = ResearchFormResult()
    let mockField = Components.Schemas.FormField(fieldId: "mock", _type: .text, label: "Mock question")
    
    
    var body: some View {
        CHOIRFormField(formField: mockField)
            .environmentObject(managedFormResult)
    }
}


#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    SkeletonCell()
}
#endif
