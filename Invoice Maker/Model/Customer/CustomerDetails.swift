//
//  CustomerDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Foundation

@Observable
class CustomerDetails {
    var id: UUID
    var name: String
    var address: String?
    var details: String?
    var phone: String?
    var email: String?

    var isInvalid: Bool {
        name.isEmpty
    }

    init(id: UUID = UUID(), name: String = "", address: String? = nil, details: String? = nil, phone: String? = nil, email: String? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.details = details
        self.phone = phone
        self.email = email
    }

    convenience init(from customer: Customer) {
        self.init(id: customer.id,
                  name: customer.name,
                  address: customer.address,
                  details: customer.details,
                  phone: customer.phone,
                  email: customer.email)
    }
}
