//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct CardColor: ShapeStyle {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        #if os(visionOS)
            .regularMaterial
        #else
            environment.colorScheme == .dark
                ? Color.choice(for: .systemGray4) : .white
        #endif
    }
}

extension ShapeStyle where Self == CardColor {
    static var cardColor: CardColor {
        CardColor()
    }
}
