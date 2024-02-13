//
//  Product+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import Foundation

extension Product {
    static let sampleData: [Product] = [
        Product(code: 1, name: "سیب", details: "یک سیب تازه.", price: 29000),
        Product(code: 2, name: "موز", details: "یک خوشه موز.", price: 34000),
        Product(code: 3, name: "پرتقال", details: "یک پرتقال.", price: 56000),
        Product(code: 4, name: "آناناس", details: "یک آناناس.", price: 100000),
        Product(code: 5, name: "توت فرنگی", details: "یک کیلو توت فرنگی.", price: 120000),
    ]
}
