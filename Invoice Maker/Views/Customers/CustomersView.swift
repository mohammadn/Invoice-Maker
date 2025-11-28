//
//  CustomersView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import ContactsUI
import SwiftData
import SwiftUI

struct CustomersView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ContactStoreManager.self) private var storeManager
    @Query(sort: \CustomerN.name) private var customers: [CustomerN]
    @State private var showCustomerFormView: Bool = false
    @State private var showContactsPicker: Bool = false
    @State private var showContactsPermissionAlert: Bool = false
    @State private var selectedCustomers: Set<CustomerN> = []
    @State private var searchText: String = ""
    @State private var editMode: EditMode = .inactive
    @State private var showDeleteConfirmation: Bool = false

    var filteredCustomers: [CustomerN] {
        if searchText.isEmpty {
            return customers
        } else {
            return customers.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) == true ||
                    ($0.phone?.localizedCaseInsensitiveContains(searchText) == true) ||
                    ($0.email?.localizedCaseInsensitiveContains(searchText) == true) ||
                    ($0.details?.localizedCaseInsensitiveContains(searchText) == true) ||
                    ($0.address?.localizedCaseInsensitiveContains(searchText) == true)
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedCustomers) {
                ForEach(filteredCustomers, id: \.self) { customer in
                    CustomersListItemView(customer: customer, editMode: $editMode)
                        .swipeActions {
                            Button("حذف", role: .destructive) {
                                delete(customer: customer)
                            }
                        }
                }

                if !searchText.isEmpty && storeManager.authorizationStatus != .authorized {
                    CustomersContactView(searchText: $searchText)
                }
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("مشتریان")
            .searchable(text: $searchText, prompt: "جستجو")
            .animation(.default, value: filteredCustomers)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if editMode.isEditing {
                        Button("حذف", systemImage: "trash", role: .destructive) {
                            showDeleteConfirmation.toggle()
                        }
                        .disabled(selectedCustomers.isEmpty)
                        .confirmationDialog("آیا مطمئن هستید؟", isPresented: $showDeleteConfirmation) {
                            Button("حذف", role: .destructive) {
                                delete(customers: selectedCustomers)
                                editMode = .inactive
                            }
                        } message: {
                            Text("آیا مطمئن هستید که می خواهید \(selectedCustomers.count) مشتری را حذف کنید؟")
                        }
                    } else {
                        Menu {
                            Button("افزودن", systemImage: "plus") {
                                showCustomerFormView.toggle()
                            }

                            Button("افزودن از مخاطبین", systemImage: "person.crop.circle.badge.plus") {
                                handleContactAuthorization()
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    if editMode.isEditing {
                        Button(role: .close) {
                            withAnimation {
                                editMode = .inactive
                                selectedCustomers.removeAll()
                            }
                        }
                    } else {
                        Button("ویرایش") {
                            withAnimation {
                                editMode = .active
                                selectedCustomers.removeAll()
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showCustomerFormView) {
                NavigationStack {
                    CustomerFormView()
                }
            }
            .contactAccessPicker(isPresented: $showContactsPicker) { identifiers in
                fetchContacts(with: identifiers)
            }
            .alert("دسترسی به مخاطبین", isPresented: $showContactsPermissionAlert) {
                Button("ادامه", role: .cancel) {
                    showContactsPermissionAlert.toggle()
                }
            } message: {
                Text("برای افزودن مشتری از مخاطبین، دسترسی به مخاطبین را از تنظیمات دیوایس خود فعال کنید.")
            }
            .overlay {
                if filteredCustomers.isEmpty && searchText.isEmpty {
                    ContentUnavailableView {
                        Label("مشتری یافت نشد", systemImage: "person.2")
                    } description: {
                        Text("برای افزودن مشتری جدید روی دکمه + کلیک کنید")
                    }
                }

                if filteredCustomers.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView {
                        Label("مشتری با این مشخصات یافت نشد", systemImage: "magnifyingglass")
                    } description: {
                        Text("برای جستجو، نام، شماره تلفن، ایمیل، آدرس یا توضیحات مشتری را وارد کنید")
                    }
                }
            }
        } detail: {
            switch selectedCustomers.count {
            case 0:
                Text("یک مشتری انتخاب کنید")
                    .font(.title)
            case 1:
                if let customer = selectedCustomers.first {
                    CustomerView(customer: customer)
                }
            default:
                Text("\(selectedCustomers.count) مشتری انتخاب شده است")
                    .font(.title)
            }
        }
    }

    private func handleContactAuthorization() {
        switch storeManager.authorizationStatus {
        case .notDetermined:
            Task {
                await storeManager.requestAccess()

                fetchContacts()
            }
        case .authorized, .limited:
            showContactsPicker.toggle()
        case .denied, .restricted:
            showContactsPermissionAlert.toggle()
        @unknown default:
            fatalError("An unknown error occurred.")
        }
    }

    private func fetchContacts() {
        Task {
            let contacts = await storeManager.fetchContacts()

            contacts.forEach { contact in
                addCustomer(from: contact)
            }
        }
    }

    private func fetchContacts(with identifiers: [String]) {
        Task {
            let contacts = await storeManager.fetchContacts(with: identifiers)

            contacts.forEach { contact in
                addCustomer(from: contact)
            }
        }
    }

    private func addCustomer(from contact: CNContact) {
        let customer = CustomerN(from: contact)

        modelContext.insert(customer)
    }

    private func delete(customer: CustomerN) {
        modelContext.delete(customer)
    }

    private func delete(customers: Set<CustomerN>) {
        for customer in customers {
            modelContext.delete(customer)
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var storeManager = ContactStoreManager()

        CustomersView()
            .modelContainer(previewContainer)
            .environment(\.layoutDirection, .rightToLeft)
            .environment(storeManager)
    }
#endif
