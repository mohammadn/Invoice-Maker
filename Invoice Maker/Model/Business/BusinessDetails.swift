//
//  BusinessDetails.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

@Observable
class BusinessDetails {
    var name: String = ""
    var address: String = ""
    var phone: String = ""
    var email: String = ""
    var website: String = ""

    init(name: String, address: String, phone: String, email: String, website: String) {
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