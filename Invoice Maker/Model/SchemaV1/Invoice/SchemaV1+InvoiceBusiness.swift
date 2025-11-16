//
//  SchemaV1+InvoiceBusiness.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/06/2025.
//

import Foundation
import SwiftData

extension SchemaV1 {
    @Model
    class InvoiceBusiness {
        var name: String?
        var phone: String?
        var email: String?
        var website: String?
        var address: String?
        var invoice: SchemaV1.Invoice?

        init(name: String?, phone: String?, email: String?, website: String?, address: String?, invoice: SchemaV1.Invoice? = nil) {
            self.name = name
            self.phone = phone
            self.email = email
            self.website = website
            self.address = address
            self.invoice = invoice
        }

        convenience init(from business: SchemaV1.Business) {
            self.init(name: business.name,
                      phone: business.phone,
                      email: business.email,
                      website: business.website,
                      address: business.address
            )
        }
    }
}

extension SchemaV1.InvoiceBusiness {
    func update(with business: SchemaV1.Business) {
        name = business.name
        phone = business.phone
        email = business.email
        website = business.website
        address = business.address
    }
}
