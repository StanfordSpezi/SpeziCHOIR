//
//  QuestionView.swift
//  TestApp
//
//  Created by Nikolai Madlener on 11.02.25.
//

import SpeziCHOIR
import SpeziCHOIRViews
import SwiftUI

struct QuestionView: View {
    var body: some View {
        CHOIRQuestions(onFinish: {}, surveySite: "")
    }
}

#Preview {
    QuestionView()
}
