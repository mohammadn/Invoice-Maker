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
    @State private var showDismissAlert: Bool = false

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
                        showDismissAlert.toggle()
                    }
                    .alert("آیا مطمئن هستید؟", isPresented: $showDismissAlert) {
                        Button("انصراف", role: .cancel) {
                            showDismissAlert.toggle()
                        }
                        Button("حذف مشتری", role: .destructive) {
                            dismiss()
                        }
                    } message: {
                        Text("اطلاعات مشتری ذخیره نشده است. در صورت ادامه دادن حذف خواهد شد.")
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
