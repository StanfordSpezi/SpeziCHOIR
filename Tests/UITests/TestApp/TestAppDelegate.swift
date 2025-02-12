//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziAccount
import SpeziCHOIR
import SpeziFirebaseAccount


class TestAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration {
            AccountConfiguration(
                service: FirebaseAccountService(
                    providers: [.emailAndPassword]
                ),
                storageProvider: TestAccountStorageProvider(),
                configuration: CHOIRMockModule.valueConfiguration
            )
            CHOIRMockModule()
        }
    }
}
