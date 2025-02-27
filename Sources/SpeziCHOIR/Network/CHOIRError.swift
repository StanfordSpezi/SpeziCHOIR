//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Represents errors that can occur when interacting with the CHOIR API.
public enum CHOIRError: LocalizedError {
    case internalServerError(message: String)
    case badRequest(message: String)
    case unauthorized(message: String)
    case notFound(message: String)
    case unknown
}
