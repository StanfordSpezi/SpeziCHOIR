//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension CHOIRError {
    /// Returns a human-readable description of the CHOIR error.
    /// - Returns: A localized string describing the error.
    public var localizedDescription: LocalizedStringResource {
        switch self {
        case CHOIRError.internalServerError:
            "The server was unable to process the request." 
        case CHOIRError.notFound:
            "The survey was not found."
        case CHOIRError.unauthorized:
            "Not allowed to request the resource. This can be caused by an unverified email."
        case CHOIRError.badRequest:
            "The server was unable to process the request."
        case CHOIRError.unknown:
            "An unknown error occurred."
        }
    }
}
