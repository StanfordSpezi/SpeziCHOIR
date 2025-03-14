<!--
                  
This source file is part of the Stanford Spezi open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

# SpeziCHOIR

[![Main](https://github.com/StanfordSpezi/SpeziCHOIR/actions/workflows/main.yml/badge.svg)](https://github.com/StanfordSpezi/SpeziCHOIR/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/StanfordSpezi/SpeziCHOIR/graph/badge.svg?token=1JtbDCelYd)](https://codecov.io/gh/StanfordSpezi/SpeziCHOIR)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14936279.svg)](https://doi.org/10.5281/zenodo.14936279)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpeziCHOIR%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/StanfordSpezi/SpeziCHOIR)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpeziCHOIR%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/StanfordSpezi/SpeziCHOIR)

Spezi CHOIR integrates ResearchKit surveys with the [Stanford CHOIR system](https://choir.stanford.edu).

|![Screenshot of question without answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/EmptyQuestion.png#gh-light-mode-only) ![Screenshot of question without answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/EmptyQuestion~dark.png#gh-dark-mode-only)|![Screenshot of question with `radios` type answer field](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/RadioQuestion.png#gh-light-mode-only) ![Screenshot of question with `radios` type answer field](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/RadioQuestion~dark.png#gh-dark-mode-only)| ![Screenshot of question with `text` type answer fields ](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/TextQuestion.png#gh-light-mode-only) ![Screenshot of question with `text` type answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/TextQuestion~dark.png#gh-dark-mode-only) |
|:--:|:--:|:--:|
|`CHOIRQuestions` rendering instructions without answer options|`CHOIRQuestions` rendering `radios` type question|`CHOIRQuestions` rendering `text` type questions|

The package contains two targets:
- [SpeziCHOIR](https://swiftpackageindex.com/StanfordSpezi/SpeziCHOIR/documentation/spezichoir): Handles interactions with the CHOIR API
- [SpeziCHOIRViews](https://swiftpackageindex.com/StanfordSpezi/SpeziCHOIR/documentation/spezichoirviews): Provides views for rendering survey questions

You use the [`CHOIRQuestions`](https://swiftpackageindex.com/stanfordspezi/spezichoir/documentation/spezichoirviews/choirquestions) view to visualize a CHOIR survey.


## Setup

### 1. Add Spezi CHOIR as a Dependency

You need to add the SpeziCHOIR Swift package to
[your app in Xcode](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app#) or
[Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode#Add-a-dependency-on-another-Swift-package).

> [!IMPORTANT]  
> If your application is not yet configured to use Spezi, follow the [Spezi setup article](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) to set up the core Spezi infrastructure.

### 2. Add the Module to your App

Add the [`CHOIRModule`](https://swiftpackageindex.com/stanfordspezi/spezichoir/documentation/spezichoir/choirmodule) to your App's configuration:
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

The [`CHOIRAccountStorageProvider`](https://swiftpackageindex.com/stanfordspezi/spezichoir/documentation/spezichoir/choiraccountstorageprovider) can be added to your App's account configuration like so:
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


## License
This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordBDHG/TemplatePackage/tree/main/LICENSES) for more information.


## Contributors
This project is developed as part of the Stanford Byers Center for Biodesign at Stanford University.
See [CONTRIBUTORS.md](https://github.com/StanfordBDHG/TemplatePackage/tree/main/CONTRIBUTORS.md) for a full list of all TemplatePackage contributors.

![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
