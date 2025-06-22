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
    var phone: String
    var email: String?
    var website: String?
    var address: String?

    var isInvalid: Bool {
        name.isEmpty || phone.isEmpty
    }

    init(name: String = "", phone: String = "", email: String? = nil, website: String? = nil, address: String? = nil) {
        self.name = name
        self.phone = phone
        self.email = email
        self.website = website
        self.address = address
    }

    convenience init(from business: Business) {
        self.init(name: business.name, phone: business.phone, email: business.email, website: business.website, address: business.address)
    }
}
