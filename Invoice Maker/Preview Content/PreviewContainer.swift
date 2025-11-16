//
//  PreviewContainer.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 17/08/2025.
//

#if DEBUG
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

            // Add sample invoices (already have relationships)
            for invoice in InvoiceN.sampleData {
                context.insert(invoice)
            }

            try context.save()
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
#endif
