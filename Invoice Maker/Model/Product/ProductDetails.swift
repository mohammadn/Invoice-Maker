//
//  ProductDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

@Observable
class ProductDetails {
    var code: Int?
    var name: String
    var price: Float?
    var details: String?

    var isInvalid: Bool {
        code == nil || name.isEmpty || price == nil
    }

    init(code: Int? = nil, name: String = "", details: String? = nil, price: Float? = nil) {
        self.code = code
        self.name = name
        self.price = price
        self.details = details
    }

    convenience init(from product: Product) {
        self.init(code: product.code, name: product.name, details: product.details, price: product.price)
    }
}
