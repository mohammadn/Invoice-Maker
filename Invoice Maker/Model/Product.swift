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
    var price: Double
    var details: String
    var createdDate: Date = Date.now

    init(code: Int, name: String, price: Double, details: String) {
        self.code = code
        self.name = name
        self.price = price
        self.details = details
    }
}
