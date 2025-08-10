//
//  ProductDetailsV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

@Observable
class ProductDetailsV1 {
    var code: Int?
    var name: String
    var price: Decimal?
    var currency: Currency
    var details: String?

    var isInvalid: Bool {
        code == nil || name.isEmpty || price == nil
    }

    init(code: Int? = nil, name: String = "", price: Decimal? = nil, currency: Currency = .IRR, details: String? = nil) {
        self.code = code
        self.name = name
        self.price = price
        self.currency = currency
        self.details = details
    }

    convenience init(from product: SchemaV1.Product) {
        self.init(code: product.code, name: product.name, price: product.price, currency: product.currency, details: product.details)
    }
}
