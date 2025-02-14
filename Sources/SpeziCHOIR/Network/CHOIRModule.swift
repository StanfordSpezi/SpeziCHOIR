//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import Spezi
import SpeziAccount

// swiftlint:disable missing_docs


/// A protocol that defines the interface for interacting with the CHOIR API.
/// 
/// This protocol defines the core methods needed to interact with the API, including
/// onboarding and continuing assessment steps.
public protocol CHOIRModuleProtocol: Module, EnvironmentAccessible {
    // periphery:ignore - false positive
    static var valueConfiguration: AccountValueConfiguration { get }
    
    @MainActor
    func onboarding(site: String) async throws -> Components.Schemas.Onboarding
    
    @MainActor
    func continueAssessmentStep(
        site: String,
        token: String,
        body: Operations.postAssessmentStep.Input.Body
    ) async throws -> Components.Schemas.AssessmentStep
}

// periphery:ignore - false positive
public enum CHOIREnvironment {
    case production
    case demo
}

/// A mock implementation of the `CHOIRModuleProtocol` that provides simulated responses for testing purposes.
/// 
/// This module returns predefined mock data with a simulated network latency to help test CHOIR API integrations
/// without requiring a connection to the actual server.
public final class CHOIRMockModule: CHOIRModuleProtocol {
    // periphery:ignore - false positive
    public static let valueConfiguration: AccountValueConfiguration = CHOIRModule.valueConfiguration
    
    /// Initializes a new mock module instance.
    public init() {}
    
    /// Simulates the onboarding process.
    /// - Parameter site: The survey site.
    /// - Returns: A mock onboarding response.
    @MainActor
    public func onboarding(site: String) async throws -> Components.Schemas.Onboarding {
        // Using existing mock implementation
        // swiftlint:disable:next line_length
        let onboardingData = try Operations.getOnboarding.Output.Ok(body: Operations.getOnboarding.Output.Ok.Body.json(Components.Schemas.Onboarding(displayStatus: Components.Schemas.DisplayStatus(compatLevel: Optional("1"), questionId: "instructions", questionType: Components.Schemas.DisplayStatus.questionTypePayload.form, surveyToken: Optional("2000716078"), stepNumber: Optional("1"), progress: nil, surveyProviderId: Optional("afibScreening"), surveySectionId: nil, surveySystemName: nil, serverValidationMessage: nil, sessionToken: Optional("1beyi33timd4i1ihajy3qz381mwyqnfxzrm24wcr1sf1618zhlxdk5rmj333eb2f4gnljkuy211phpwlz1pfda7"), sessionStatus: Components.Schemas.DisplayStatus.sessionStatusPayload.question, resumeToken: Optional("449xongzvekinnc0t4s03jam13let0islhrthpdjpx9kq0s5h17ieeao9runlepbw3ysmsnbxt8l03jpr8ik5i"), resumeTimeoutMillis: Optional("30000"), styleSheetName: Optional("afib-2024-04-29.cache.css"), pageTitle: Optional("Stanford Heartbeat Study"), locale: "en", showBack: Optional(false)), question: Components.Schemas.FormQuestion(title1: "<div class=\"intro\">\n<p class=\"blue-text\">Welcome to Stanford Heartbeat Study!</p></div>", title2: nil, serverValidationMessage: nil, terminal: nil, fields: Optional([Components.Schemas.FormField(fieldId: "instructions", _type: Components.Schemas.FormField._typePayload.heading, label: Optional("<p class=\"blue-text\">Please click the \'Continue\' button to start the screening survey.</p>"), required: nil, min: nil, max: nil, attributes: nil, values: nil)]))))).body.json
        try await Task.sleep(for: .milliseconds(300)) // simulate 300ms network latency
        return onboardingData
    }
    
    /// Simulates the continuation of an assessment step.
    /// - Parameters:
    ///   - site: The survey site.
    ///   - token: The survey token.
    ///   - body: The body of the assessment step.
    /// - Returns: A mock assessment step response.
    @MainActor
    public func continueAssessmentStep(
        site: String,
        token: String,
        body: Operations.postAssessmentStep.Input.Body
    ) async throws -> Components.Schemas.AssessmentStep {
        // Using existing mock implementation
        // swiftlint:disable:next line_length
        let assessmentStepData = try Operations.postAssessmentStep.Output.Ok(body: Operations.postAssessmentStep.Output.Ok.Body.json(Components.Schemas.AssessmentStep(displayStatus: Components.Schemas.DisplayStatus(compatLevel: Optional("1"), questionId: "Order1", questionType: Components.Schemas.DisplayStatus.questionTypePayload.form, surveyToken: Optional("2000716078"), stepNumber: Optional("2"), progress: nil, surveyProviderId: Optional("1000"), surveySectionId: Optional("1128"), surveySystemName: nil, serverValidationMessage: nil, sessionToken: Optional("1beyi33timd4i1ihajy3qz381mwyqnfxzrm24wcr1sf1618zhlxdk5rmj333eb2f4gnljkuy211phpwlz1pfda7"), sessionStatus: Components.Schemas.DisplayStatus.sessionStatusPayload.question, resumeToken: nil, resumeTimeoutMillis: nil, styleSheetName: Optional("afib-2024-04-29.cache.css"), pageTitle: Optional("Stanford Heartbeat Study"), locale: "en", showBack: Optional(false)), question: Components.Schemas.AssessmentStep.questionPayload(value1: Optional(Components.Schemas.FormQuestion(title1: "<div class=\"intro\">\n<p class=\"blue-text\">Thank you!</p></div>", title2: Optional("I am completing this questionnaire for:"), serverValidationMessage: nil, terminal: true, fields: Optional([Components.Schemas.FormField(fieldId: "1:0:patient_age", _type: Components.Schemas.FormField._typePayload.radios, label: Optional(""), required: Optional(true), min: nil, max: nil, attributes: nil, values: Optional([Components.Schemas.FormFieldValue(id: "1", label: "Myself. I am 18 years of age or older, and I am interested in learning more about a clinical trial opportunity", fields: nil), Components.Schemas.FormFieldValue(id: "0", label: "Myself. I am younger than 18 years, and I am interested in learning more about a clinical trial opportunity", fields: nil)]))]))))))).body.json
        try await Task.sleep(for: .milliseconds(300)) // simulate 300ms network latency
        return assessmentStepData
    }
}

/// A module implementation of the `CHOIRModuleProtocol` that provides a real network connection to the CHOIR API.
public final class CHOIRModule: CHOIRModuleProtocol {
    public static let valueConfiguration: AccountValueConfiguration = [
        .requires(\.userId),
        .supports(\.name),
        .supports(\.phoneNumber)
    ]
    
    internal let client: Client
    
    /// Initializes a new CHOIR module instance.
    /// - Parameter environment: The environment to use for the CHOIR module.
    // periphery:ignore - false positive
    public init(environment: CHOIREnvironment) {
        switch environment {
        case .production:
            self.client = Client(
                // swiftlint:disable:next force_try
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport(),
                middlewares: [FirebaseAuthMiddleware()]
            )
        case .demo:
            self.client = Client(
                // swiftlint:disable:next force_try
                serverURL: try! Servers.Server2.url(),
                transport: URLSessionTransport(),
                middlewares: [FirebaseAuthMiddleware()]
            )
        }
    }
    
    /// Initially loads the assessment step and the survey token for subsequent steps needed in `continueAssessmentStep`.
    /// - Parameter site: The survey site.
    /// - Returns: The onboarding response.
    @MainActor
    public func onboarding(site: String) async throws -> Components.Schemas.Onboarding {
        let onboardingData = try await client.getOnboarding(path: .init(site: site), headers: .init(accept: [.init(contentType: .json)]))
        switch onboardingData {
        case .ok:
            return try onboardingData.ok.body.json
        case .internalServerError(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.internalServerError(message: errorMessage)
        case .badRequest(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.badRequest(message: errorMessage)
        case .unauthorized(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.unauthorized(message: errorMessage)
        default:
            throw CHOIRError.unknown
        }
    }
    
    /// Continues to the next assessment step.
    /// - Parameters:
    ///   - site: The survey site.
    ///   - token: The survey token.
    ///   - body: The body of the assessment step.
    /// - Returns: The assessment step response.
    @MainActor
    public func continueAssessmentStep(
        site: String,
        token: String,
        body: Operations.postAssessmentStep.Input.Body
    ) async throws -> Components.Schemas.AssessmentStep {
        let assessmentStepData = try await client.postAssessmentStep(
            path: .init(site: site, surveyToken: token),
            headers: .init(accept: [.init(contentType: .json)]),
            body: body
        )
        switch assessmentStepData {
        case .ok:
            return try assessmentStepData.ok.body.json
        case .internalServerError(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.internalServerError(message: errorMessage)
        case .badRequest(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.badRequest(message: errorMessage)
        case .notFound(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.notFound(message: errorMessage)
        case .unauthorized(let response):
            let errorMessage = await convertToString(httpBody: try response.body.plainText)
            throw CHOIRError.unauthorized(message: errorMessage)
        default:
            throw CHOIRError.unknown
        }
    }
    
    @MainActor
    func convertToString(httpBody: OpenAPIRuntime.HTTPBody) async -> String {
        do {
            return try await String(collecting: httpBody, upTo: .max)
        } catch {
            return "Unkown error."
        }
    }
}
