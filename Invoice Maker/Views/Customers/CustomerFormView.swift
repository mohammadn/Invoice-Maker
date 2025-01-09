//
//  CustomerFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import SwiftUI

struct CustomerFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var customerDetails: CustomerDetails

    var onSave: (CustomerDetails) -> Void

    init(customer: Customer? = nil, onSave: @escaping (CustomerDetails) -> Void) {
        if let customer {
            _customerDetails = State(initialValue: CustomerDetails(from: customer))
        } else {
            _customerDetails = State(initialValue: CustomerDetails())
        }

        self.onSave = onSave
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
                        onSave(customerDetails)
                        dismiss()
                    }
                    .disabled(customerDetails.isInvalid)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        dismiss()
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
