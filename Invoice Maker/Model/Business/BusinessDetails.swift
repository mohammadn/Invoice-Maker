//
//  BusinessDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

@Observable
class BusinessDetails {
    var name: String
    var address: String?
    var phone: String?
    var email: String?
    var website: String?

    var isInvalid: Bool {
        name.isEmpty
    }

    init(name: String = "", address: String? = nil, phone: String? = nil, email: String? = nil, website: String? = nil) {
        self.name = name
        self.address = address
        self.phone = phone
        self.email = email
        self.website = website
    }

    convenience init(from business: Business) {
        self.init(name: business.name, address: business.address, phone: business.phone, email: business.email, website: business.website)
    }
}
