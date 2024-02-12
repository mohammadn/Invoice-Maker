//
//  ProductsAddView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import SwiftUI

struct ProductsAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var code: String = ""
    @State private var name: String = ""
    @State private var details: String = ""
    @State private var price: String = ""
    private var isSaveDisabled: Bool {
        code.isEmpty || name.isEmpty || price.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("کد کالا", text: $code)
                        .keyboardType(.numberPad)
                }

                Section {
                    TextField("نام کالا", text: $name)
                    TextField("جزئیات", text: $details, axis: .vertical)
                        .lineLimit(3 ... 5)
                }

                Section {
                    TextField("قیمت", text: $price)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("افزودن کالا")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ذخیره", action: save)
                        .disabled(isSaveDisabled)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func save() {
        let product = Product(code: Int(code)!, name: name, details: details, price: Double(price)!)
        modelContext.insert(product)
        dismiss()
    }
}

#Preview {
    ProductsAddView()
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
