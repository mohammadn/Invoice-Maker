//
//  SchemaV1+Invoice+Option.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 16/08/2025.
//

extension SchemaV1.Invoice {
    enum Option: String, Codable, CaseIterable {
        case dueDate

        var label: String {
            switch self {
            case .dueDate: "تاریخ سررسید"
            }
        }
    }
}
