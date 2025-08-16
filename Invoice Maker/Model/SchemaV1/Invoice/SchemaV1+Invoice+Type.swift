//
//  SchemaV1+Invoice+Type.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 16/08/2025.
//

extension SchemaV1.Invoice {
    enum InvoiceType: String, Codable, CaseIterable {
        case sale, proforma

        var label: String {
            switch self {
            case .sale: "فاکتور فروش"
            case .proforma: "پیش فاکتور فروش"
            }
        }

        init(from value: Invoice.InvoiceType) {
            switch value {
            case .sale:
                self = .sale
            case .proforma:
                self = .proforma
            }
        }
    }
}
