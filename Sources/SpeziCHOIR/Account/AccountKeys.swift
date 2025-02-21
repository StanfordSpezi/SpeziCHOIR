//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable attributes file_types_order missing_docs no_extension_access_modifier

import Foundation
import OpenAPIRuntime
import SpeziAccount
import SwiftUI


extension AccountDetails {
    @AccountKey(
        name: "Phone",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    
    public var phoneNumber: String?
}

@KeyEntry(\.phoneNumber)

public extension AccountKeys {}
