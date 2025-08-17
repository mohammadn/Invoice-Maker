//
//  PreviewContainer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/08/2025.
//

import Foundation
import SwiftData

@MainActor
public let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: BusinessN.self, InvoiceN.self, Product.self, CustomerN.self,
            configurations: config
        )

        let context = container.mainContext

        // Add sample business
        let business = BusinessN.sampleData
        context.insert(business)

        // Add sample customers
        for customer in CustomerN.sampleData {
            context.insert(customer)
        }

        // Add sample products
        for product in Product.sampleData {
            context.insert(product)
        }

        // Add sample invoices with relationships
        for invoice in InvoiceN.sampleData {
            let invoiceBusiness = InvoiceBusiness(from: BusinessN.sampleData)
            let invoiceCustomer = InvoiceCustomer(from: CustomerN.sampleData.first!)
            let itemDetails = Product.sampleData.map { ItemDetails(from: $0, quantity: 1) }
            let invoiceItems = itemDetails.map { InvoiceItem(from: $0) }

            invoice.business = invoiceBusiness
            invoice.customer = invoiceCustomer
            invoice.items = invoiceItems

            context.insert(invoice)
        }

        try context.save()
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
