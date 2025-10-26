//
//  BusinessDetailsV1.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

@Observable
class BusinessDetailsV1 {
    var name: String
    var phone: String
    var email: String
    var website: String
    var address: String

    var isInvalid: Bool {
        name.isEmpty || phone.isEmpty
    }

    init(name: String = "", phone: String = "", email: String = "", website: String = "", address: String = "") {
        self.name = name
        self.phone = phone
        self.email = email
        self.website = website
        self.address = address
    }

    convenience init(from business: SchemaV1.Business) {
        self.init(name: business.name ?? "",
                  phone: business.phone ?? "",
                  email: business.email ?? "",
                  website: business.website ?? "",
                  address: business.address ?? "")
    }
}
