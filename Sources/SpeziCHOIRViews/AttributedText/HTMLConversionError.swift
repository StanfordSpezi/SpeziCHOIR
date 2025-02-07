//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


/// Errors that can occur during HTML to AttributedString conversion
enum HTMLConversionError: Error {
    case encodingFailed
    case conversionFailed(underlying: Error)
}
