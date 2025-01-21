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
    var details: String?
    var price: Int
    var createdDate: Date = Date.now

    init(code: Int, name: String, details: String?, price: Int) {
        self.code = code
        self.name = name
        self.details = details
        self.price = price
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
        details = productDetails.details
        price = productDetails.price ?? 0
    }
}
