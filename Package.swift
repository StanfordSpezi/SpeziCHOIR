// swift-tools-version:6.0
//
// This source file is part of the Stanford Spezi open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription


let package = Package(
    name: "SpeziCHOIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(name: "SpeziCHOIR", targets: ["SpeziCHOIR"]),
        .library(name: "SpeziCHOIRViews", targets: ["SpeziCHOIRViews"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordSpezi/SpeziAccount.git", from: "2.1.2"),
        .package(url: "https://github.com/StanfordSpezi/SpeziFirebase.git", from: "2.0.1"),
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.6.0"),
        .package(url: "https://github.com/StanfordBDHG/ResearchKit.git", from: "4.0.0-beta.2")
    ] + swiftLintPackage(),
    targets: [
        .target(
            name: "SpeziCHOIR",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "SpeziAccount", package: "SpeziAccount"),
                .product(name: "SpeziFirebaseAccount", package: "SpeziFirebase"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ] + swiftLintPlugin()
        ),
        .target(
            name: "SpeziCHOIRViews",
            dependencies: [
                .target(name: "SpeziCHOIR"),
                .product(name: "ResearchKitSwiftUI", package: "ResearchKit"),
                .product(name: "ResearchKit", package: "ResearchKit")
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "SpeziCHOIRTests",
            dependencies: [
                .target(name: "SpeziCHOIR")
            ],
            plugins: [] + swiftLintPlugin()
        )
    ]
)


func swiftLintPlugin() -> [Target.PluginUsage] {
    // Fully quit Xcode and open again with `open --env SPEZI_DEVELOPMENT_SWIFTLINT /Applications/Xcode.app`
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
    } else {
        []
    }
}

func swiftLintPackage() -> [PackageDescription.Package.Dependency] {
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.package(url: "https://github.com/realm/SwiftLint.git", from: "0.55.1")]
    } else {
        []
    }
}
