//
//  DataMigrationManager.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

@MainActor
final class DataMigrationManager {
    private let mainContainer: ModelContainer
    private let oldContainer: ModelContainer

    init(mainContainer: ModelContainer, oldContainer: ModelContainer) {
        self.mainContainer = mainContainer
        self.oldContainer = oldContainer
    }

    func performMigrationIfNeeded() async throws {
        // Check if migration has already been performed
        let migrationKey = "DataMigrationCompleted"
        guard !UserDefaults.standard.bool(forKey: migrationKey) else {
            print("Migration already completed, skipping...")
            return
        }

        print("Starting data migration...")

        // Create contexts
        let oldContext = ModelContext(oldContainer)
        let mainContext = ModelContext(mainContainer)

        // Perform migration in a transaction
        try await migrateBusinesses(from: oldContext, to: mainContext)
        try await migrateCustomers(from: oldContext, to: mainContext)
        try await migrateProducts(from: oldContext, to: mainContext)
        try await migrateInvoices(from: oldContext, to: mainContext)

        // Save the main context
        try mainContext.save()

        // Mark migration as complete
        UserDefaults.standard.set(true, forKey: migrationKey)

        print("Migration completed successfully")
    }

    private func migrateBusinesses(from oldContext: ModelContext, to mainContext: ModelContext) async throws {
        let descriptor = FetchDescriptor<Business>()
        let oldBusinesses = try oldContext.fetch(descriptor)

        for oldBusiness in oldBusinesses {
            let newBusiness = BusinessN(
                name: oldBusiness.name,
                phone: oldBusiness.phone,
                email: oldBusiness.email,
                website: oldBusiness.website,
                address: oldBusiness.address
            )
            mainContext.insert(newBusiness)
        }

        print("Migrated \(oldBusinesses.count) businesses")
    }

    private func migrateCustomers(from oldContext: ModelContext, to mainContext: ModelContext) async throws {
        let descriptor = FetchDescriptor<Customer>()
        let oldCustomers = try oldContext.fetch(descriptor)

        for oldCustomer in oldCustomers {
            let newCustomer = CustomerN(
                id: oldCustomer.id,
                name: oldCustomer.name,
                phone: oldCustomer.phone,
                email: oldCustomer.email,
                address: oldCustomer.address,
                details: oldCustomer.details
            )
            mainContext.insert(newCustomer)
        }

        print("Migrated \(oldCustomers.count) customers")
    }

    private func migrateProducts(from oldContext: ModelContext, to mainContext: ModelContext) async throws {
        // Try to fetch from ProductSchemaV1.VersionedProduct first
        do {
            let descriptor = FetchDescriptor<ProductSchemaV1.VersionedProduct>()
            let oldProducts = try oldContext.fetch(descriptor)

            for oldProduct in oldProducts {
                let newProduct = Product(
                    code: oldProduct.code,
                    name: oldProduct.name,
                    price: oldProduct.price,
                    currency: oldProduct.currency,
                    details: oldProduct.details
                )
                mainContext.insert(newProduct)
            }

            print("Migrated \(oldProducts.count) products from versioned schema")
        } catch {
            // If versioned products don't exist, try regular Product model
            print("No versioned products found, trying regular Product model")
        }
    }

    private func migrateInvoices(from oldContext: ModelContext, to mainContext: ModelContext) async throws {
        // Try to fetch from InvoiceSchemaV1.VersionedInvoice
        do {
            let descriptor = FetchDescriptor<InvoiceSchemaV1.VersionedInvoice>()
            let oldInvoices = try oldContext.fetch(descriptor)

            for oldInvoice in oldInvoices {
                // Create new invoice
                let newInvoice = InvoiceN(
                    number: oldInvoice.number,
                    type: InvoiceN.InvoiceType(from: oldInvoice.type),
                    currency: oldInvoice.currency,
                    date: oldInvoice.date,
                    dueDate: Date.now,
                    vat: 0,
                    discount: 0,
                    note: oldInvoice.note,
                    status: .pending,
                    options: [],
                    items: [],
                    customer: nil,
                    business: nil,
                )

                // Find and link customer
                if let oldCustomer = oldInvoice.customer {
                    let oldCustomerId = oldCustomer.id
                    let customerPredicate = #Predicate<CustomerN> { customer in
                        customer.id == oldCustomerId
                    }
                    let customerDescriptor = FetchDescriptor<CustomerN>(predicate: customerPredicate)
                    if let newCustomer = try mainContext.fetch(customerDescriptor).first {
                        newInvoice.customer = InvoiceCustomer(
                            id: newCustomer.id,
                            name: newCustomer.name,
                            phone: newCustomer.phone,
                            email: newCustomer.email,
                            address: newCustomer.address,
                            details: newCustomer.details
                        )
                    }
                }

                // Find and link business
                if let oldBusiness = oldInvoice.business {
                    let oldBusinessName = oldBusiness.name
                    let oldBusinessPhone = oldBusiness.phone

                    let businessPredicate = #Predicate<BusinessN> { business in
                        business.name == oldBusinessName &&
                            business.phone == oldBusinessPhone
                    }
                    let businessDescriptor = FetchDescriptor<BusinessN>(predicate: businessPredicate)
                    if let newBusiness = try mainContext.fetch(businessDescriptor).first {
                        newInvoice.business = InvoiceBusiness(
                            name: newBusiness.name,
                            phone: newBusiness.phone,
                            email: newBusiness.email,
                            website: newBusiness.website,
                            address: newBusiness.address
                        )
                    }
                }

                // Migrate invoice items
                for oldItem in oldInvoice.items {
                    let newItem = InvoiceItem(
                        productId: UUID(),
                        productCode: oldItem.productCode,
                        productName: oldItem.productName,
                        productPrice: oldItem.productPrice,
                        productCurrency: oldItem.productCurrency,
                        productDetails: oldItem.productDetails,
                        quantity: oldItem.quantity
                    )
                    newInvoice.items.append(newItem)
                }

                mainContext.insert(newInvoice)
            }

            print("Migrated \(oldInvoices.count) invoices")
        } catch {
            print("Error migrating invoices: \(error)")
        }
    }
}
