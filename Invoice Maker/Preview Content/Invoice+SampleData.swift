//
//  Invoice+SampleData.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 12/02/2024.
//

import Foundation

extension InvoiceN {
    @MainActor
    static let sampleData: [InvoiceN] = {
        let invoice = InvoiceN(
            number: "14040101003",
            type: .sale,
            currency: .IRR,
            date: Date(timeIntervalSince1970: 1742579120),
            dueDate: Date(),
            vat: 10,
            discount: 5,
            note: "",
            status: .pending,
            options: [],
            items: [],
            customer: InvoiceCustomer(from: CustomerN.sampleData.first!),
            business: InvoiceBusiness(from: BusinessN.sampleData)
        )

        // Add sample items
        let itemDetails = Product.sampleData.map { ItemDetails(from: $0, quantity: 1) }
        let invoiceItems = itemDetails.map { InvoiceItem(from: $0) }

        invoice.items = invoiceItems

        return [invoice]
    }()
}
