//
//  Product.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation
import SwiftData

@Model
class Product {
    @Attribute(.unique) var code: Int
    var name: String
    var price: Float
    var details: String?
    var createdDate: Date = Date.now

    init(code: Int, name: String, details: String?, price: Float) {
        self.code = code
        self.name = name
        self.price = price
        self.details = details
    }

    convenience init(from productDetails: ProductDetails) {
        self.init(code: productDetails.code ?? 0,
                  name: productDetails.name,
                  details: productDetails.details,
                  price: productDetails.price ?? 0)
    }
}

extension Product {
    func update(with productDetails: ProductDetails) {
        code = productDetails.code ?? 0
        name = productDetails.name
        price = productDetails.price ?? 0
        details = productDetails.details
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.code == rhs.code &&
            lhs.name == rhs.name &&
            lhs.price == rhs.price &&
            lhs.details == rhs.details
    }
}

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(name)
        hasher.combine(price)
        hasher.combine(details)
    }
}
