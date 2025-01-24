//
//  CustomerFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import SwiftUI

struct CustomerFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var customerDetails: CustomerDetails
    @State private var showDismissAlert: Bool = false

    var customer: Customer?

    init(customer: Customer? = nil) {
        self.customer = customer

        if let customer {
            _customerDetails = State(initialValue: CustomerDetails(from: customer))
        } else {
            _customerDetails = State(initialValue: CustomerDetails())
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("نام*", text: $customerDetails.name)
                    TextField("جزئیات", text: $customerDetails.details ?? "", axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section {
                    TextField("تلفن", text: $customerDetails.phone ?? "")
                        .keyboardType(.phonePad)
                    TextField("آدرس", text: $customerDetails.address ?? "", axis: .vertical)
                        .lineLimit(3 ... 5)
                }

                Section {
                    TextField("ایمیل", text: $customerDetails.email ?? "")
                        .keyboardType(.emailAddress)
                }
            }
            .navigationBarTitle("افزودن مشتری")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ذخیره") {
                        if let customer {
                            customer.update(with: customerDetails)
                        } else {
                            let customer = Customer(from: customerDetails)
                            
                            modelContext.insert(customer)
                        }
                        dismiss()
                    }
                    .disabled(customerDetails.isInvalid)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        showDismissAlert.toggle()
                    }
                    .alert("آیا مطمئن هستید؟", isPresented: $showDismissAlert) {
                        Button("انصراف", role: .cancel) {
                            showDismissAlert.toggle()
                        }
                        Button("بازگشت") {
                            dismiss()
                        }
                    } message: {
                        Text("در صورت بازگشت به صفحه قبل اطلاعات مشتری ذخیره نخواهد شد.")
                    }
                }
            }
        }
    }
}

//
// #Preview {
//    CustomerFormView { _ in }
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
