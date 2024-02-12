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
    var details: String
    var price: Double
    var createdDate: Date = Date.now

    init(code: Int, name: String, details: String, price: Double) {
        self.code = code
        self.name = name
        self.details = details
        self.price = price
    }

    convenience init?(from productDetails: ProductDetails) {
        if let code = productDetails.code,
           let price = productDetails.price {
            self.init(code: code, name: productDetails.name, details: productDetails.details, price: Double(price))
        } else {
            return nil
        }
    }
}

extension Product {
    func update(with productDetails: ProductDetails) {
        if let code = productDetails.code,
           let price = productDetails.price {
            self.code = code
            self.price = Double(price)
        }

        name = productDetails.name
        details = productDetails.details
    }
}
