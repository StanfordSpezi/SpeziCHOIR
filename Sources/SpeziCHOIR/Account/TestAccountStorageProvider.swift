//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziAccount


/// A mock storage provider that can be used for testing purposes.
public actor TestAccountStorageProvider: AccountStorageProvider {
    @Dependency(AccountDetailsCache.self) private var localCache

    public init() {}

    public func load(_ accountId: String, _ keys: [any AccountKey.Type]) async -> AccountDetails? {
        if let entry = await localCache.loadEntry(for: accountId, keys) {
            return entry
        }
        var details = AccountDetails()
        details.phoneNumber = "+1 (555) 555-5555"
        await localCache.communicateRemoteChanges(for: accountId, details)
        return details
    }

    public func store(_ accountId: String, _ details: AccountDetails) async throws {
        await localCache.communicateRemoteChanges(for: accountId, details)
    }

    public func store(_ accountId: String, _ modifications: AccountModifications) async throws {
        await localCache.communicateModifications(for: accountId, modifications)
    }

    public func disassociate(_ accountId: String) async {
        await localCache.clearEntry(for: accountId)
    }

    public func delete(_ accountId: String) async throws {
        await disassociate(accountId)
    }
}
