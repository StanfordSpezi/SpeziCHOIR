//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// periphery:ignore:all - false positive

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import SpeziAccount


/// A storage provider that uses the CHOIR API to store and retrieve account details.
public actor CHOIRAccountStorageProvider: AccountStorageProvider {
    @Application(\.logger) private var logger
    @Dependency(Account.self) private var account
    @Dependency(CHOIRModule.self) private var choir
    @Dependency(AccountDetailsCache.self) private var localCache
    @Dependency(ExternalAccountStorage.self) private var externalStorage

    let siteId: String
    private var registeredKeys = [String: [ObjectIdentifier: any AccountKey.Type]]()
    private var reloadTasks = [String: Task<Void, Never>]()
    
    
    public init(siteId: String) {
        self.siteId = siteId
    }
    

    private func reload(_ accountId: String) {
        guard reloadTasks[accountId] == nil else {
            return
        }
        reloadTasks[accountId] = Task {
            defer { reloadTasks[accountId] = nil }
            do {
                let user = try await choir.choirService.client.getParticipant(
                    path: .init(site: siteId),
                    headers: .init(accept: [.init(contentType: .json)])
                ).ok.body.json
                var details = AccountDetails()
                details.name = PersonNameComponents(givenName: user.firstName, familyName: user.lastName)
                details.email = user.email
                if let phone = user.mobilePhone ?? user.homePhone {
                    details.phoneNumber = phone
                }
            
                try Task.checkCancellation()
                await localCache.communicateRemoteChanges(for: accountId, details)
                
                externalStorage.notifyAboutUpdatedDetails(for: accountId, details)
            } catch {
                logger.error("Reloading account details failed: \(error)")
                var details = AccountDetails()
                details.userId = accountId
                await localCache.communicateRemoteChanges(for: accountId, details)
                externalStorage.notifyAboutUpdatedDetails(for: accountId, details)
                return
            }
        }
    }

    public func load(_ accountId: String, _ keys: [any AccountKey.Type]) async -> AccountDetails? {
        registeredKeys[accountId] = keys.reduce(into: [:]) { result, key in
            result[ObjectIdentifier(key)] = key
        }
        defer { reload(accountId) }
        return await localCache.loadEntry(for: accountId, keys)
    }

    public func store(_ accountId: String, _ details: AccountDetails) async throws {
        let user = Components.Schemas.Participant(
            firstName: details.name?.givenName ?? "",
            lastName: details.name?.familyName ?? "",
            email: details.email ?? "",
            mobilePhone: details.phoneNumber ?? ""
        )
        
        _ = try await choir.choirService.client.postParticipant(
            path: .init(site: siteId),
            body: .json(user)
        ).ok
        
        externalStorage.notifyAboutUpdatedDetails(for: accountId, details)
    }

    public func store(_ accountId: String, _ modifications: AccountModifications) async throws {
        var newDetails = await account.details ?? AccountDetails()
        newDetails.add(contentsOf: modifications.modifiedDetails, merge: true)
        try await store(accountId, newDetails)
    }

    public func disassociate(_ accountId: String) async {
        reloadTasks.removeValue(forKey: accountId)?.cancel()
        registeredKeys.removeValue(forKey: accountId)
        
        await localCache.clearEntry(for: accountId)
    }

    public func delete(_ accountId: String) async throws {
        await disassociate(accountId)
        
        _ = try await choir.choirService.client.unenrollParticipant(
            path: .init(site: siteId)
        ).ok
    }
}
