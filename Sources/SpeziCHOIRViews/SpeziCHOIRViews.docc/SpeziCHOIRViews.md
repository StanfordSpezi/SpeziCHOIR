# ``SpeziCHOIRViews``

<!--

This source file is part of the Stanford Spezi open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
       
-->

## Overview

SpeziCHOIRViews contains the necessary views to render CHOIR style questions with ResearchKit UI components.

|![Screenshot of question without answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/EmptyQuestion.png#gh-light-mode-only) ![Screenshot of question without answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/EmptyQuestion~dark.png#gh-dark-mode-only)|![Screenshot of question with `radios` type answer field](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/RadioQuestion.png#gh-light-mode-only) ![Screenshot of question with `radios` type answer field](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/RadioQuestion~dark.png#gh-dark-mode-only)| ![Screenshot of question with `text` type answer fields ](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/TextQuestion.png#gh-light-mode-only) ![Screenshot of question with `text` type answer fields](Sources/SpeziCHOIRViews/SpeziCHOIRViews.docc/Resources/TextQuestion~dark.png#gh-dark-mode-only) |
|:--:|:--:|:--:|
|`CHOIRQuestions` rendering instructions without answer options|`CHOIRQuestions` rendering `radios` type question|`CHOIRQuestions` rendering `text` type questions|

You use the `CHOIRQuestions` view to visualize a CHOIR survey.


## Usage

The `CHOIRQuestions` view allows you to integrate CHOIR surveys into your SwiftUI application. It handles the rendering and interaction with CHOIR survey questions.

> [!IMPORTANT]
> `CHOIRQuestions` should be wrapped in a `NavigationStack` so that the view can properly render the survey title in the navigation title. When using `CHOIRQuestions` within ``SpeziOnboarding`` ([GitHub](https://github.com/StanfordSpezi/SpeziOnboarding)) it's not necessary to wrap it (as SpeziOnboarding's OnboardingStack already provides a NavigationStack).

Here's a simple example of how to use `CHOIRQuestions`:
```
struct MyView: View {
    var body: some View {
        NavigationStack {
            CHOIRQuestions(onFinish: handleFinish, surveySite: "example-survey")
        }
    }
}
```

Here's an example of how to use `CHOIRQuestions` within ``SpeziOnboarding``:
```
struct MyOnboardingView: View {
    var body: some View {
        OnboardingStack {
            CHOIRQuestions(onFinish: handleFinish, surveySite: "example-survey")
        }
    }
}
```

## Types

- ``CHOIRQuestions``
