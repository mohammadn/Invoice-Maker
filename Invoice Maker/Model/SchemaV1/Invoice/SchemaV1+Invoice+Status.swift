//
//  SchemaV1+Invoice+Status.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 16/08/2025.
//

extension SchemaV1.Invoice {
    enum Status: String, Codable, CaseIterable {
        case invalid, draft, expired, pending, cancelled, paid

        var label: String {
            switch self {
            case .invalid: "نامعتبر"
            case .draft: "پیش نویس"
            case .expired: "منقضی"
            case .pending: "آماده پرداخت"
            case .cancelled: "لغو شده"
            case .paid: "پرداخت شده"
            }
        }
    }
}
