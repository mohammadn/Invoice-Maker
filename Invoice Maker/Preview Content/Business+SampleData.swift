//
//  Business+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

extension Business {
    @MainActor
    static let sampleData = Business(name: "نمونه شرکت",
                                     phone: "تهران، ایران",
                                     email: "۰۲۱۲۲۲۲۲۲۲۲",
                                     website: "test@example.com",
                                     address: "www.example.com")
}
