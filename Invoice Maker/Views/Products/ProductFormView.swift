//
//  ProductFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import SwiftUI

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var productDetails: ProductDetails
//    @State private var showDismissAlert: Bool = false

    var product: Product?
    var dismissAction: (() -> Void)?

    init(product: Product? = nil, dismissAction: (() -> Void)? = nil) {
        self.product = product
        self.dismissAction = dismissAction

        if let product {
            _productDetails = State(initialValue: ProductDetails(from: product))
        } else {
            _productDetails = State(initialValue: ProductDetails())
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("کد*", value: $productDetails.code, format: .number)
                    .keyboardType(.numberPad)
            }

            Section {
                TextField("نام محصول*", text: $productDetails.name)
                TextField("جزئیات", text: $productDetails.details ?? "", axis: .vertical)
                    .lineLimit(2 ... 4)
            }

            Section {
                TextField("قیمت (ریال)*", value: $productDetails.price, format: .number)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationBarTitle(product == nil ? "افزودن محصول" : "ویرایش محصول")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("ذخیره") {
                    save()

                    dismissAction?() ?? dismiss()
                }
                .disabled(productDetails.isInvalid)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button("انصراف") {
//                        showDismissAlert.toggle()
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
//                        Text("در صورت بازگشت به صفحه قبل اطلاعات محصول ذخیره نخواهد شد.")
//                    }
            }
        }
    }

    private func save() {
        productDetails.details = productDetails.details?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let product {
            product.update(with: productDetails)
        } else {
            let product = Product(from: productDetails)

            modelContext.insert(product)
        }
    }
}

// #Preview {
//    ProductFormView { _ in }
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
