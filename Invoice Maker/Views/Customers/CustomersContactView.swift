//
//  CustomersContactView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 26/01/2025.
//

import ContactsUI
import SwiftUI

struct CustomersContactView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismissSearch) private var dismissSearch
    @Environment(ContactStoreManager.self) private var storeManager

    @Binding var searchText: String

    var body: some View {
        Section("جستجوی مخاطبین") {
            ContactAccessButton(queryString: searchText) { identifiers in
                fetchContacts(with: identifiers)
            }
            .contactAccessButtonCaption(.phone)
        }
    }

    private func fetchContacts(with identifiers: [String]) {
        Task {
            let contacts = await storeManager.fetchContacts(with: identifiers)

            contacts.forEach { contact in
                addCustomer(from: contact)
            }

            dismissSearch()
        }
    }

    private func addCustomer(from contact: CNContact) {
        let customer = CustomerN(from: contact)

        modelContext.insert(customer)
    }
}

// #Preview {
//    CustomersContactView()
// }
