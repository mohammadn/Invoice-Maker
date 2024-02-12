//
//  Product+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation

extension Product {
    static let sampleData: [Product] = [
        Product(code: 1, name: "سیب", details: "یک سیب تازه.", price: 1.00),
        Product(code: 2, name: "موز", details: "یک خوشه موز.", price: 1.50),
        Product(code: 3, name: "پرتقال", details: "یک پرتقال.", price: 2.00),
        Product(code: 4, name: "آناناس", details: "یک آناناس.", price: 3.00),
        Product(code: 5, name: "توت فرنگی", details: "یک کیلو توت فرنگی.", price: 4.00),
    ]
}
