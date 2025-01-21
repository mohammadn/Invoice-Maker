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
    @State private var showDismissAlert: Bool = false

    var product: Product?
    //    var onSave: (ProductDetails) -> Void

    init(product: Product? = nil) {
        self.product = product

        if let product {
            _productDetails = State(initialValue: ProductDetails(from: product))
        } else {
            _productDetails = State(initialValue: ProductDetails())
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("کد کالا*", value: $productDetails.code, format: .number)
                        .keyboardType(.numberPad)
                }

                Section {
                    TextField("نام کالا*", text: $productDetails.name)
                    TextField("جزئیات", text: $productDetails.details ?? "", axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section {
                    TextField("قیمت*", value: $productDetails.price, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("افزودن کالا")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ذخیره") {
                        if let product {
                            product.update(with: productDetails)
                        } else {
                            let product = Product(from: productDetails)

                            modelContext.insert(product)
                        }
                        dismiss()
                    }
                    .disabled(productDetails.isInvalid)
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
                        Text("در صورت بازگشت به صفحه قبل اطلاعات محصول ذخیره نخواهد شد.")
                    }
                }
            }
        }
    }
}

// #Preview {
//    ProductFormView { _ in }
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
