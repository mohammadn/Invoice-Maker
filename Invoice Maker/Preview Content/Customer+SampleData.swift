//
//  Customer+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Foundation

extension Customer {
    @MainActor
    static let sampleData: [Customer] = [
        Customer(name: "محمد علی پور", address: "تهران، ایران", details: "توضیحات مشتری", phone: "0212222222", email: "mohammad@example.com"),
        Customer(name: "حسین صمدی", address: "مشهد، ایران", details: "توضیحات مشتری", phone: "0512222222", email: "hossein@example.com"),
        Customer(name: "سارا محمدی", address: "اصفهان، ایران", details: "توضیحات مشتری", phone: "0312222222", email: "sara@example.com"),
    ]
}
