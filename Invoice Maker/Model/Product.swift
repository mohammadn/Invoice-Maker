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
}
