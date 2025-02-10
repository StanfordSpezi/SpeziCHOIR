//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

/// todo docs
public enum CHOIRError: Error {
    case internalServerError(message: String)
    case badRequest(message: String)
    case unauthorized(message: String)
    case notFound(message: String)
    case unknown
}
