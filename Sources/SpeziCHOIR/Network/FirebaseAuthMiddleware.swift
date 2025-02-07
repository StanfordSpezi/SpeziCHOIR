//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import Foundation
import HTTPTypes
import OpenAPIRuntime
import OpenAPIURLSession


// periphery:ignore - false positive
internal final class FirebaseAuthMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (
            HTTPTypes.HTTPRequest,
            OpenAPIRuntime.HTTPBody?,
            URL
        ) async throws -> (
            HTTPTypes.HTTPResponse,
            OpenAPIRuntime.HTTPBody?)
    ) async throws -> (
        HTTPTypes.HTTPResponse,
        OpenAPIRuntime.HTTPBody?
    ) {
        guard let user = Auth.auth().currentUser,
              let token = try await Auth.auth().getIdToken(currentUser: user, forcingRefresh: true) else {
            throw URLError(.noPermissionsToReadFile)
        }
        var request = request
        request.headerFields[.authorization] = "Bearer \(token)"
        return try await next(request, body, baseURL)
    }
}

extension Auth {
    fileprivate func getIdToken(currentUser: User, forcingRefresh forceRefresh: Bool) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            currentUser.getIDTokenForcingRefresh(forceRefresh) { token, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: token)
                }
            }
        }
    }
}
