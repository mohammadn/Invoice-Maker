//
//  Invoice.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 14/02/2024.
//

import Foundation
import SwiftData

@Model
class Invoice {
    var number: String
    var customer: Customer
    var date: Date
    var items: [Item] = []
    var note: String
    var type: InvoiceType
    var createdDate: Date = Date.now

    init(number: String = "", customer: Customer, date: Date = .now, note: String = "", type: InvoiceType = .sale) {
        self.number = number
        self.customer = customer
        self.date = date
        self.note = note
        self.type = type
    }
}

extension Invoice {
    enum InvoiceType: Codable, CaseIterable {
        case sale, purchase, proforma

        var label: String {
            switch self {
            case .sale: "فروش"
            case .purchase: "خرید"
            case .proforma: "پیش فاکتور"
            }
        }
    }
}
