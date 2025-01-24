//
//  CustomersView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import SwiftData
import SwiftUI

struct CustomersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Customer.createdDate) private var customers: [Customer]
    @State private var showCustomerFormView: Bool = false
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
                        showCustomerFormView.toggle()
                    }
                }
            }
            .sheet(isPresented: $showCustomerFormView) {
                CustomerFormView()
            }
            .sheet(item: $selectedCustomer) { customer in
                CustomerFormView(customer: customer)
            }
            .overlay {
                if customers.isEmpty {
                    ContentUnavailableView {
                        Label("مشتری یافت نشد", systemImage: "person.2")
                    } description: {
                        Text("برای افزودن مشتری جدید روی دکمه + کلیک کنید")
                    }
                }
            }
        }
    }

    private func delete(at indexSet: IndexSet) {
        indexSet.forEach { index in
            modelContext.delete(customers[index])
        }
    }
}

// #Preview {
//    CustomersView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
