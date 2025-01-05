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
    var note: String
    var type: InvoiceType
    var items: [Item]
    var createdDate: Date = Date.now

    var total: Int {
        items.reduce(0) { $0 + ($1.quantity * $1.product.price) }
    }

    init(number: String = "", customer: Customer, date: Date = .now, note: String = "", type: InvoiceType = .sale, items: [Item] = []) {
        self.number = number
        self.customer = customer
        self.date = date
        self.note = note
        self.type = type
        self.items = items
    }

    convenience init?(from invoiceDetails: InvoiceDetails) {
        guard let customer = invoiceDetails.customer else { return nil }

        self.init(number: invoiceDetails.number,
                  customer: customer,
                  date: invoiceDetails.date,
                  note: invoiceDetails.note,
                  type: invoiceDetails.type)

        items = invoiceDetails.items.map { Item(product: $0.product, quantity: $0.quantity) }
    }
}

extension Invoice {
    enum InvoiceType: Codable, CaseIterable {
        case sale, proforma

        var label: String {
            switch self {
            case .sale: "فاکتور فروش"
            case .proforma: "پیش فاکتور فروش"
            }
        }
    }
}

extension Invoice {
    func update(with invoiceDetails: InvoiceDetails) {
        guard let customer = invoiceDetails.customer else { return }

        number = invoiceDetails.number
        self.customer = customer
        date = invoiceDetails.date
        note = invoiceDetails.note
        type = invoiceDetails.type
        items = invoiceDetails.items.map { Item(product: $0.product, quantity: $0.quantity) }
    }
}
