# ``SpeziCHOIRViews``

<!--

This source file is part of the Stanford Spezi open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
       
-->

## Overview

SpeziCHOIRViews contains the necessary views to render CHOIR style questions with ResearchKit UI components.

@Row {
    @Column {
        @Image(source: "EmptyQuestion", alt: "Screenshot of question without answer fields") {
            `CHOIRQuestions` rendering instructions without answer options.
        }
    }
    @Column {
        @Image(source: "RadioQuestion", alt: "Screenshot of question with radios type answer field") {
            `CHOIRQuestions` rendering `radios` type question.
        }
    }
    @Column {
        @Image(source: "TextQuestion", alt: "Screenshot of question with text type answer fields") {
            `CHOIRQuestions` rendering `text` type questions.
        }
    }
}


## Usage

The `CHOIRQuestions` view allows you to integrate CHOIR surveys into your SwiftUI application. It handles the rendering and interaction with CHOIR survey questions.

> Important: `CHOIRQuestions` should be wrapped in a `NavigationStack` so that the view can properly render the survey title in the navigation title. When using `CHOIRQuestions` within ``SpeziOnboarding`` ([GitHub](https://github.com/StanfordSpezi/SpeziOnboarding)) it's not necessary to wrap it (as SpeziOnboarding's OnboardingStack already provides a NavigationStack).

Here's a simple example of how to use `CHOIRQuestions`:
```swift
struct MyView: View {
    var body: some View {
        NavigationStack {
            CHOIRQuestions(onFinish: handleFinish, surveySite: "example-survey")
        }
    }
}
```

Here's an example of how to use `CHOIRQuestions` within ``SpeziOnboarding``:
```swift
struct MyOnboardingView: View {
    var body: some View {
        OnboardingStack {
            CHOIRQuestions(onFinish: handleFinish, surveySite: "example-survey")
        }
    }
}
```

## Topics

### Presenting CHOIR questions

- ``CHOIRQuestions``
