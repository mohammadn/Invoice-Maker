//
//  Customer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 13/02/2024.
//

import Foundation
import SwiftData

@Model
class Customer {
    var name: String
    var address: String?
    var details: String?
    var phone: String?
    var email: String?
    var invoices: [Invoice] = []
    var createdDate: Date = Date.now

    init(name: String, address: String?, details: String?, phone: String?, email: String?) {
        self.name = name
        self.address = address
        self.details = details
        self.phone = phone
        self.email = email
    }

    convenience init(from customerDetails: CustomerDetails) {
        self.init(name: customerDetails.name,
                  address: customerDetails.address,
                  details: customerDetails.details,
                  phone: customerDetails.phone,
                  email: customerDetails.email)
    }
}

extension Customer {
    func update(with customerDetails: CustomerDetails) {
        name = customerDetails.name
        address = customerDetails.address
        details = customerDetails.details
        phone = customerDetails.phone
        email = customerDetails.email
    }
}
