//
//  SchemaV1+Product.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class Product {
        @Attribute(.unique) var code: Int
        var name: String
        var price: Decimal
        var currency: Currency
        var details: String?
        var createdDate: Date = Date.now

        init(code: Int, name: String, price: Decimal, currency: Currency, details: String?) {
            self.code = code
            self.name = name
            self.price = price
            self.currency = currency
            self.details = details
        }

        convenience init(from productDetails: ProductDetailsV1) {
            self.init(code: productDetails.code ?? 0,
                      name: productDetails.name,
                      price: productDetails.price ?? 0,
                      currency: productDetails.currency,
                      details: productDetails.details)
        }
    }
}

extension SchemaV1.Product {
    func update(with productDetails: ProductDetailsV1) {
        code = productDetails.code ?? 0
        name = productDetails.name
        price = productDetails.price ?? 0
        currency = productDetails.currency
        details = productDetails.details
    }
}

extension SchemaV1.Product: Equatable {
    static func == (lhs: SchemaV1.Product, rhs: SchemaV1.Product) -> Bool {
        lhs.code == rhs.code &&
            lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.currency == rhs.currency &&
            lhs.details == rhs.details
    }
}

extension SchemaV1.Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
