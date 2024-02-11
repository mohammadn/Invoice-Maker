//
//  Product+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation

extension Product {
    static let sampleData: [Product] = [
        Product(code: 1, name: "سیب", price: 1.00, details: "یک سیب تازه."),
        Product(code: 2, name: "موز", price: 1.50, details: "یک خوشه موز."),
        Product(code: 3, name: "پرتقال", price: 2.00, details: "یک پرتقال."),
        Product(code: 4, name: "آناناس", price: 3.00, details: "یک آناناس."),
        Product(code: 5, name: "توت فرنگی", price: 4.00, details: "یک کیلو توت فرنگی."),
    ]
}
