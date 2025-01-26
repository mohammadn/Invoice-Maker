/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 An observable class that manages reading data from the contact store.
 */

@preconcurrency import Contacts
import OSLog

@MainActor
@Observable
final class ContactStoreManager {
    /// Contains the Contacts authorization status for the app.
    var authorizationStatus: CNAuthorizationStatus

    private let logger = Logger(subsystem: "ContactsAccess", category: "ContactStoreManager")
    private let store: CNContactStore
    private let keysToFetch: [any CNKeyDescriptor]

    init() {
        store = CNContactStore()
        authorizationStatus = .notDetermined
        keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as any CNKeyDescriptor,
            CNContactEmailAddressesKey as any CNKeyDescriptor,
            CNContactPostalAddressesKey as any CNKeyDescriptor,
        ]
    }

    /// Fetches the Contacts authorization status of the app.
    func fetchAuthorizationStatus() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    }

    /// Prompts the person for access to Contacts if the authorization status of the app can't be determined.
    func requestAccess() async {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .notDetermined else { return }

        do {
            try await store.requestAccess(for: .contacts)

            // Update the authorization status of the app.
            fetchAuthorizationStatus()
        } catch {
            fetchAuthorizationStatus()
            logger.error("Requesting Contacts access failed: \(error)")
        }
    }

    /// Fetches all contacts authorized for the app and whose identifiers match a given list of identifiers.
    func fetchContacts(with identifiers: [String]) async -> [CNContact] {
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.sortOrder = .familyName
        fetchRequest.predicate = CNContact.predicateForContacts(withIdentifiers: identifiers)

        return await executeFetchRequest(fetchRequest)
    }

    /// Fetches all contacts authorized for the app.
    func fetchContacts() async -> [CNContact] {
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        fetchRequest.sortOrder = .familyName

        return await executeFetchRequest(fetchRequest)
    }

    /// Executes the fetch request.
    private nonisolated func executeFetchRequest(_ fetchRequest: CNContactFetchRequest) async -> [CNContact] {
        var result: [CNContact] = []

        do {
            try await store.enumerateContacts(with: fetchRequest) { contact, _ in
                result.append(contact)
            }
        } catch {
            logger.error("Fetching contacts failed: \(error)")
        }

        return result
    }
}
