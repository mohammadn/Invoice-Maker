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

    var onSave: (ProductDetails) -> Void

    init(product: Product? = nil, onSave: @escaping (ProductDetails) -> Void) {
        if let product {
            _productDetails = State(initialValue: ProductDetails(from: product))
        } else {
            _productDetails = State(initialValue: ProductDetails())
        }

        self.onSave = onSave
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
                    TextField("جزئیات", text: $productDetails.details, axis: .vertical)
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
                        onSave(productDetails)
                        dismiss()
                    }
                    .disabled(productDetails.isInvalid)
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

#Preview {
    ProductFormView { _ in }
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
