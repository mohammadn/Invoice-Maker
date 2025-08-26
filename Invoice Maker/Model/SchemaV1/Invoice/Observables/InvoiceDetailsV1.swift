//
//  InvoiceDetailsV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 25/02/2024.
//

import Foundation

@Observable
class InvoiceDetailsV1 {
    var number: String
    var type: SchemaV1.Invoice.InvoiceType
    var currency: Currency
    var date: Date
    var dueDate: Date
    var vat: Decimal?
    var discount: Decimal?
    var note: String
    var status: SchemaV1.Invoice.Status
    var options: [SchemaV1.Invoice.Option]
    var items: [ItemDetailsV1]
    var customerId: UUID?
    var customerName: String?
    var customerAddress: String?
    var customerDetails: String?
    var customerPhone: String?
    var customerEmail: String?

    var isInvalid: Bool {
        number.isEmpty || customerId == nil || items.isEmpty
    }

    init(number: String = "",
         type: SchemaV1.Invoice.InvoiceType = .sale,
         currency: Currency = .IRR,
         date: Date = .now,
         dueDate: Date = .now,
         vat: Decimal? = nil,
         discount: Decimal? = nil,
         note: String = "",
         status: SchemaV1.Invoice.Status = .pending,
         options: [SchemaV1.Invoice.Option] = [],
         items: [ItemDetailsV1] = [],
         customerId: UUID? = nil,
         customerName: String? = nil,
         customerAddress: String? = nil,
         customerDetails: String? = nil,
         customerPhone: String? = nil,
         customerEmail: String? = nil,
    ) {
        self.number = number
        self.type = type
        self.currency = currency
        self.date = date
        self.dueDate = dueDate
        self.vat = vat
        self.discount = discount
        self.note = note
        self.status = status
        self.options = options
        self.items = items
        self.customerId = customerId
        self.customerName = customerName
        self.customerAddress = customerAddress
        self.customerDetails = customerDetails
        self.customerPhone = customerPhone
        self.customerEmail = customerEmail
    }

    convenience init(from invoice: SchemaV1.Invoice) {
        self.init(number: invoice.number,
                  type: invoice.type,
                  currency: invoice.currency,
                  date: invoice.date,
                  dueDate: invoice.dueDate,
                  vat: invoice.vat,
                  discount: invoice.discount,
                  note: invoice.note,
                  status: invoice.status,
                  options: invoice.options,
                  items: invoice.items.map { item in ItemDetailsV1(from: item) },
                  customerId: invoice.customer?.id,
                  customerName: invoice.customer?.name,
                  customerAddress: invoice.customer?.address,
                  customerDetails: invoice.customer?.details,
                  customerPhone: invoice.customer?.phone,
                  customerEmail: invoice.customer?.email,
        )
    }
}

extension InvoiceDetailsV1: Equatable {
    static func == (lhs: InvoiceDetailsV1, rhs: InvoiceDetailsV1) -> Bool {
        let areItemsEqual: Bool = lhs.items.elementsEqual(rhs.items)

        return lhs.number == rhs.number &&
            lhs.type == rhs.type &&
            lhs.currency == rhs.currency &&
            lhs.date == rhs.date &&
            lhs.dueDate == rhs.dueDate &&
            lhs.vat == rhs.vat &&
            lhs.discount == rhs.discount &&
            lhs.note == rhs.note &&
            lhs.status == rhs.status &&
            lhs.options == rhs.options &&
            areItemsEqual &&
            lhs.customerId == rhs.customerId &&
            lhs.customerName == rhs.customerName &&
            lhs.customerAddress == rhs.customerAddress &&
            lhs.customerDetails == rhs.customerDetails &&
            lhs.customerPhone == rhs.customerPhone &&
            lhs.customerEmail == rhs.customerEmail
    }
}

extension InvoiceDetailsV1: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(type)
        hasher.combine(currency)
        hasher.combine(date)
        hasher.combine(dueDate)
        hasher.combine(vat)
        hasher.combine(discount)
        hasher.combine(note)
        hasher.combine(status)
        hasher.combine(options)
        hasher.combine(customerId)
        hasher.combine(customerName)
        hasher.combine(customerAddress)
        hasher.combine(customerDetails)
        hasher.combine(customerPhone)
        hasher.combine(customerEmail)
    }
}
