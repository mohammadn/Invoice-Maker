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
    var details: String

    var isInvalid: Bool {
        code == nil || name.isEmpty || price == nil
    }

    var isDirty: Bool {
        code != nil || !name.isEmpty || price != nil || !details.isEmpty
    }

    init(code: Int? = nil, name: String = "", price: Decimal? = nil, currency: Currency = .IRR, details: String = "") {
        self.code = code
        self.name = name
        self.price = price
        self.currency = currency
        self.details = details
    }

    convenience init(from product: SchemaV1.Product) {
        self.init(code: product.code, name: product.name ?? "", price: product.price, currency: product.currency ?? .IRR, details: product.details ?? "")
    }
}

extension ProductDetailsV1: Equatable {
    static func == (lhs: ProductDetailsV1, rhs: ProductDetailsV1) -> Bool {
        lhs.code == rhs.code &&
            lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.currency == rhs.currency &&
            lhs.details == rhs.details
    }
}
