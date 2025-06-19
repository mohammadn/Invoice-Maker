//
//  InvoiceSchemaV1+Customer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension InvoiceSchemaV1 {
    @Model
    class InvoiceCustomer {
        var id: UUID
        var name: String
        var phone: String?
        var email: String?
        var address: String?
        var details: String?
        var invoice: VersionedInvoice?

        init(id: UUID, name: String, phone: String? = nil, email: String? = nil, address: String? = nil, details: String? = nil) {
            self.id = id
            self.name = name
            self.phone = phone
            self.email = email
            self.address = address
            self.details = details
        }

        convenience init(from customer: Customer) {
            self.init(id: customer.id,
                      name: customer.name,
                      phone: customer.phone,
                      email: customer.email,
                      address: customer.address,
                      details: customer.details)
        }
    }
}

extension InvoiceSchemaV1.InvoiceCustomer {
    func update(with customer: Customer) {
        id = customer.id
        name = customer.name
        phone = customer.phone
        email = customer.email
        address = customer.address
        details = customer.details
    }
}
