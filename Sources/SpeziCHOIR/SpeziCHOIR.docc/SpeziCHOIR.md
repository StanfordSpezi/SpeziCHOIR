# ``SpeziCHOIR``

<!--

This source file is part of the Stanford Spezi open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
       
-->

Spezi CHOIR contains the necessary CHOIR type generation, account configuration and networking middleware for interacting with the CHOIR API.


## Setup

### 1. Add Spezi CHOIR as a Dependency

You need to add the SpeziCHOIR Swift package to
[your app in Xcode](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app#) or
[Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode#Add-a-dependency-on-another-Swift-package).

> Important: If your application is not yet configured to use Spezi, follow the [Spezi setup article](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) to set up the core Spezi infrastructure.

### 2. Add the Module to your App Configuration

Add the `CHOIRModule` to your App's configuration:
```swift
import Spezi
import SpeziCHOIR

class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration {
            CHOIRModule(service: CHOIRService(serverURL: URL(string: "https://choir.example.com")!))
            // your other modules...
        }
    }
}
```

The `CHOIRAccountStorageProvider` can be added to your App's account configuration like so:
```swift
import Spezi
import SpeziAccount
import SpeziCHOIR
import SpeziFirebaseAccount

class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration {
             AccountConfiguration(
                service: FirebaseAccountService(
                    providers: [.emailAndPassword]
                ),
                storageProvider: CHOIRAccountStorageProvider(siteId: "exampleSite"),
                configuration: CHOIRService.valueConfiguration
            )
            // your other modules...
        }
    }
}
```

## Topics

### Account Provider Configuration 

- ``CHOIRAccountStorageProvider``
- ``TestAccountStorageProvider``

### CHOIR Service Configuration

- ``CHOIRModule``
- ``CHOIRService``
- ``CHOIRMockService``
- ``CHOIRError``
