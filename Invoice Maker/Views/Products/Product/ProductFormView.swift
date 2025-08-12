//
//  ProductFormView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import SwiftData
import SwiftUI

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var products: [Product]
    @State private var productDetails: ProductDetails
    @State private var duplicateCode: Bool = false

    var product: Product?
    var dismissAction: (() -> Void)?

    init(product: Product? = nil, dismissAction: (() -> Void)? = nil) {
        self.product = product
        self.dismissAction = dismissAction

        if let product {
            _productDetails = State(initialValue: ProductDetails(from: product))
        } else {
            let defaultCurrency = UserDefaults.standard.string(forKey: "defaultCurrency") ?? "IRR"
            let currency = Currency(rawValue: defaultCurrency) ?? .IRR

            _productDetails = State(initialValue: ProductDetails(currency: currency))
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("کد*", value: $productDetails.code, format: .number)
                    .keyboardType(.numberPad)
                    .onChange(of: productDetails.code, validateCode)
            } footer: {
                if duplicateCode {
                    Text("این کد قبلا استفاده شده است")
                        .foregroundStyle(.red)
                }
            }

            Section {
                TextField("نام محصول*", text: $productDetails.name)
                TextField("قیمت*", value: $productDetails.price, format: .number)
                    .keyboardType(.decimalPad)

                Picker("نوع ارز", selection: $productDetails.currency) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Text(currency.label).tag(currency)
                    }
                }
            }

            Section {
                TextField("توضیحات", text: $productDetails.details ?? "", axis: .vertical)
                    .lineLimit(2 ... 4)
            }
        }
        .navigationTitle(product == nil ? "افزودن محصول" : "ویرایش محصول")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("ذخیره") {
                    save()

                    dismissAction?() ?? dismiss()
                }
                .disabled(productDetails.isInvalid || duplicateCode)
            }

            ToolbarItem(placement: .topBarLeading) {
                Button("انصراف") {
                    dismissAction?() ?? dismiss()
                }
            }
        }
    }

    private func validateCode() {
        duplicateCode = products.contains { $0.code == productDetails.code && $0.persistentModelID != product?.persistentModelID }
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
