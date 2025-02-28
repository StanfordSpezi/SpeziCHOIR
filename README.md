<!--
                  
This source file is part of the Stanford Spezi open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

# SpeziCHOIR

[![Build and Test](https://github.com/StanfordSpezi/SpeziCHOIR/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/StanfordSpezi/SpeziCHOIR/actions/workflows/build-and-test.yml)

Spezi CHOIR integrates ResearchKit surveys with the Stanford CHOIR API.

|![Screenshot of question without answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/EmptyQuestion.png#gh-light-mode-only) ![Screenshot of question without answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/EmptyQuestion~dark.png#gh-dark-mode-only)|![Screenshot of question with `radios` type answer field](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/RadioQuestion.png#gh-light-mode-only) ![Screenshot of question with `radios` type answer field](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/RadioQuestion~dark.png#gh-dark-mode-only)| ![Screenshot of question with `text` type answer fields ](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/TextQuestion.png#gh-light-mode-only) ![Screenshot of question with `text` type answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/TextQuestion~dark.png#gh-dark-mode-only) |
|:--:|:--:|:--:|
|`CHOIRQuestions` rendering instructions without answer options|`CHOIRQuestions` rendering `radios` type question|`CHOIRQuestions` rendering `text` type questions|

The package contains two targets:
- `SpeziCHOIR`: Handles interactions with the CHOIR API
- `SpeziCHOIRViews`: Provides views for rendering survey questions

You use the `CHOIRQuestions` view to visualize a CHOIR survey.


## Setup

### 1. Add Spezi CHOIR as a Dependency

You need to add the SpeziCHOIR Swift package to
[your app in Xcode](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app#) or
[Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode#Add-a-dependency-on-another-Swift-package).

> [!IMPORTANT]  
> If your application is not yet configured to use Spezi, follow the [Spezi setup article](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) to set up the core Spezi infrastructure.

### 2. Add the Module to your App

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


## License
This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordBDHG/TemplatePackage/tree/main/LICENSES) for more information.


## Contributors
This project is developed as part of the Stanford Byers Center for Biodesign at Stanford University.
See [CONTRIBUTORS.md](https://github.com/StanfordBDHG/TemplatePackage/tree/main/CONTRIBUTORS.md) for a full list of all TemplatePackage contributors.

![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
