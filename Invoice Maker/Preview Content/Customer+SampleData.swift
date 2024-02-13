//
//  Customer+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Foundation

extension Customer {
    static let sampleData: [Customer] = [
        Customer(name: "محمد علی پور", address: "تهران، ایران", details: "جزئیات مشتری", phone: "0212222222", email: "mohammad@example.com"),
        Customer(name: "حسین صمدی", address: "مشهد، ایران", details: "جزئیات مشتری", phone: "0512222222", email: "hossein@example.com"),
        Customer(name: "مریم محمدی", address: "تبریز، ایران", details: "جزئیات مشتری", phone: "0412222222", email: "maryam@example.com"),
        Customer(name: "سارا محمدی", address: "اصفهان، ایران", details: "جزئیات مشتری", phone: "0312222222", email: "sara@example.com"),
    ]
}
