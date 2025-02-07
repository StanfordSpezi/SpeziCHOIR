//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable attributes file_types_order missing_docs no_extension_access_modifier

import Foundation
import OpenAPIRuntime
import SpeziAccount
import SwiftUI


public enum PreferredCommunication: String, CaseIterable, Codable, Hashable, Sendable {
    case email
    case sms
    
    internal var internalType: Components.Schemas.Participant.contactPreferencePayload {
        switch self {
        case .email: .Email
        case .sms: .Text
        }
    }
    
    internal init(internalType: Components.Schemas.Participant.contactPreferencePayload) {
        self = switch internalType {
        case .Email: .email
        case .Text: .sms
        }
    }
}

private struct PreferredCommunicationDisplayView: DataDisplayView {
    private let value: PreferredCommunication
    
    var body: some View {
        LabeledContent("Preferred Communication") {
            Text(value.rawValue)
        }
    }
    
    init(_ value: PreferredCommunication) {
        self.value = value
    }
}

private struct PreferredCommunicationEntryView: DataEntryView {
    @Binding private var value: PreferredCommunication
    
    var body: some View {
        Picker("Preferred Communication", selection: $value) {
            ForEach(PreferredCommunication.allCases, id: \.self) { value in
                Text(value.rawValue)
            }
        }
    }
    
    init(_ value: Binding<PreferredCommunication>) {
        self._value = value
    }
}

extension AccountDetails {
    @AccountKey(
        name: "Organization",
        category: .name,
        as: String.self,
        initial: .empty("")
    )
    public var organization: String?
    
    @AccountKey(
        name: "Street",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    public var street: String?
    
    @AccountKey(
        name: "City",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    public var city: String?
    
    @AccountKey(
        name: "State",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    public var state: String?
    
    @AccountKey(
        name: "Postal Code",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    public var postalCode: String?
    
    @AccountKey(
        name: "Country",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    public var country: String?
    
    @AccountKey(
        name: "Phone",
        category: .contactDetails,
        as: String.self,
        initial: .empty("")
    )
    public var phoneNumber: String?
    
    @AccountKey(
        name: "Preferred Communication",
        category: .other,
        as: PreferredCommunication.self,
        initial: .default(.email),
        displayView: PreferredCommunicationDisplayView.self,
        entryView: PreferredCommunicationEntryView.self
    )
    public var preferredCommunication: PreferredCommunication?
}

@KeyEntry(\.organization)
@KeyEntry(\.street)
@KeyEntry(\.city)
@KeyEntry(\.state)
@KeyEntry(\.country)
@KeyEntry(\.postalCode)
@KeyEntry(\.phoneNumber)
@KeyEntry(\.preferredCommunication)
public extension AccountKeys {}
