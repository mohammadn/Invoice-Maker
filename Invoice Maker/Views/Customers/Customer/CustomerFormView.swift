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
//    @State private var showDismissAlert: Bool = false

    var customer: Customer?
    var dismissAction: (() -> Void)?

    init(customer: Customer? = nil, dismissAction: (() -> Void)? = nil) {
        self.customer = customer
        self.dismissAction = dismissAction

        if let customer {
            _customerDetails = State(initialValue: CustomerDetails(from: customer))
        } else {
            _customerDetails = State(initialValue: CustomerDetails())
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("نام*", text: $customerDetails.name)
                TextField("شماره تماس", text: $customerDetails.phone ?? "")
                    .keyboardType(.phonePad)
            }

            Section {
                TextField("ایمیل", text: $customerDetails.email ?? "")
                    .keyboardType(.emailAddress)
                TextField("آدرس", text: $customerDetails.address ?? "", axis: .vertical)
                    .lineLimit(3 ... 5)
            }

            Section {
                TextField("توضیحات", text: $customerDetails.details ?? "", axis: .vertical)
                    .lineLimit(2 ... 4)
            }
        }
        .navigationBarTitle(customer == nil ? "افزودن مشتری" : "ویرایش مشتری")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("ذخیره") {
                    save()

                    dismissAction?() ?? dismiss()
                }
                .disabled(customerDetails.isInvalid)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("انصراف") {
                    dismissAction?() ?? dismiss()
                }
//                    .alert("آیا مطمئن هستید؟", isPresented: $showDismissAlert) {
//                        Button("انصراف", role: .cancel) {
//                            showDismissAlert.toggle()
//                        }
//                        Button("بازگشت") {
//                            dismiss()
//                        }
//                    } message: {
//                        Text("در صورت بازگشت به صفحه قبل اطلاعات مشتری ذخیره نخواهد شد.")
//                    }
            }
        }
    }

    private func save() {
        customerDetails.details = customerDetails.details?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let customer {
            customer.update(with: customerDetails)
        } else {
            let customer = Customer(from: customerDetails)

            modelContext.insert(customer)
        }
    }
}

//
// #Preview {
//    CustomerFormView { _ in }
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
