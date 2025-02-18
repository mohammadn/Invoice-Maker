//
//  InvoiceDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 25/02/2024.
//

import Foundation

@Observable
class InvoiceDetails {
    var number: String
    var customer: Customer?
    var date: Date
    var note: String
    var type: Invoice.InvoiceType
    var items: [(product: Product, quantity: Int)]

    var isInvalid: Bool {
        number.isEmpty || customer == nil || items.isEmpty
    }

    init(number: String = "",
         customer: Customer? = nil,
         date: Date = .now,
         note: String = "",
         type: Invoice.InvoiceType = .sale,
         items: [(product: Product, quantity: Int)] = []) {
        self.number = number
        self.customer = customer
        self.date = date
        self.note = note
        self.type = type
        self.items = items
    }

    convenience init(from invoice: Invoice) {
        self.init(number: invoice.number,
                  customer: invoice.customer,
                  date: invoice.date,
                  note: invoice.note,
                  type: invoice.type,
                  items: invoice.items.map { ($0.product, $0.quantity) })
    }
}

extension InvoiceDetails: Equatable {
    static func == (lhs: InvoiceDetails, rhs: InvoiceDetails) -> Bool {
        let areItemsEqual: Bool = lhs.items.elementsEqual(rhs.items) { $0.product == $1.product && $0.quantity == $1.quantity }

        return lhs.number == rhs.number &&
            lhs.customer == rhs.customer &&
            lhs.date == rhs.date &&
            lhs.note == rhs.note &&
            lhs.type == rhs.type &&
            areItemsEqual
    }
}
