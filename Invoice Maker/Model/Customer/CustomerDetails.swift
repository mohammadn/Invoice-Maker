//
//  CustomerDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Foundation

@Observable
class CustomerDetails {
    var name: String
    var address: String?
    var details: String?
    var phone: String?
    var email: String?

    var isInvalid: Bool {
        name.isEmpty
    }

    init(name: String = "", address: String? = nil, details: String? = nil, phone: String? = nil, email: String? = nil) {
        self.name = name
        self.address = address
        self.details = details
        self.phone = phone
        self.email = email
    }

    convenience init(from customer: Customer) {
        self.init(name: customer.name,
                  address: customer.address,
                  details: customer.details,
                  phone: customer.phone,
                  email: customer.email)
    }
}
