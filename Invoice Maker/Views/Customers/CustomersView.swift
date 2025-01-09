//
//  CustomersView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import SwiftData
import SwiftUI

struct CustomersView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Customer.createdDate) private var customers: [Customer]
    @State private var isCustomerFormViewPresented: Bool = false
    @State private var selectedCustomer: Customer?

    var body: some View {
        NavigationStack {
            List {
                ForEach(customers) { customer in
                    VStack(alignment: .leading) {
                        LabeledContent {
                            HStack {
                                Text(customer.phone ?? "-")
                                    .lineLimit(1)

                                Button {
                                    selectedCustomer = customer
                                } label: {
                                    Image(systemName: "info.circle")
                                        .font(.title3)
                                }
                            }
                        } label: {
                            Text(customer.name)
                                .lineLimit(1)
                        }

                        Text(customer.email ?? "-")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("مشتریان")
            .toolbar {
                ToolbarItemGroup {
                    Button("اضافه", systemImage: "plus") {
                        isCustomerFormViewPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $isCustomerFormViewPresented) {
                CustomerFormView(onSave: add)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .sheet(item: $selectedCustomer) { customer in
                CustomerFormView(customer: customer, onSave: update)
                    .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }

    private func add(_ customerDetails: CustomerDetails) {
        let customer = Customer(from: customerDetails)

        context.insert(customer)
    }

    private func update(_ customerDetails: CustomerDetails) {
        selectedCustomer?.update(with: customerDetails)
    }

    private func delete(at indexSet: IndexSet) {
        indexSet.forEach { index in
            context.delete(customers[index])
        }
    }
}

// #Preview {
//    CustomersView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
