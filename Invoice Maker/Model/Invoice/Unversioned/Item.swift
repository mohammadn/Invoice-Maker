//
//  Item.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 15/02/2024.
//

import SwiftData

@Model
class Item {
    var product: Product
    var quantity: Int
    var invoice: Invoice?

    init(product: Product, quantity: Int = 1, invoice: Invoice? = nil) {
        self.product = product
        self.quantity = quantity
        self.invoice = invoice
    }
}
