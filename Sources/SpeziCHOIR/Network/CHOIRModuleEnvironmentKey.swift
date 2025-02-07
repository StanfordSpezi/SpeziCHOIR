//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUICore


/// The environment key to access the CHOIR module implementation.
struct CHOIRModuleEnvironmentKey: @preconcurrency EnvironmentKey {
    #if DEBUG
    @MainActor static let defaultValue: CHOIRModuleProtocol = CHOIRMockModule()
    #else
    @MainActor static let defaultValue: CHOIRModuleProtocol = CHOIRModule(environment: .demo)
    #endif
}

extension EnvironmentValues {
    /// The CHOIR module implementation used for network requests.
    public var choirModule: CHOIRModuleProtocol {
        get { self[CHOIRModuleEnvironmentKey.self] }
        set { self[CHOIRModuleEnvironmentKey.self] = newValue }
    }
}
