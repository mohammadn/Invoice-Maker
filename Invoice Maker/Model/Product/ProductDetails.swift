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
    var details: String?
    var price: Float?

    var isInvalid: Bool {
        code == nil || name.isEmpty || price == nil
    }

    init(code: Int? = nil, name: String = "", details: String? = nil, price: Float? = nil) {
        self.code = code
        self.name = name
        self.details = details
        self.price = price
    }

    convenience init(from product: Product) {
        self.init(code: product.code, name: product.name, details: product.details, price: product.price)
    }
}
