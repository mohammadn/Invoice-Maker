//
//  Invoice_MakerApp.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

@main
struct Invoice_MakerApp: App {
    @State private var storeManager = ContactStoreManager()

    private let container: ModelContainer
    private let oldContainer: ModelContainer?
    private var persianCalendar: Calendar {
        var calendar = Calendar(identifier: .persian)
        calendar.firstWeekday = 7
        return calendar
    }

    init() {
        let mainStoreURL = URL.documentsDirectory.appending(path: "main.store")
        let mainConfig = ModelConfiguration(schema: Schema([BusinessN.self, InvoiceN.self, Product.self, CustomerN.self]), url: mainStoreURL)
        do {
            container = try ModelContainer(for: BusinessN.self, InvoiceN.self, Product.self, CustomerN.self, migrationPlan: MigrationPlan.self, configurations: mainConfig)
        } catch {
            fatalError("Failed to initialize main model container.")
        }

        do {
            oldContainer = try ModelContainer(for: Business.self, InvoiceSchemaV1.VersionedInvoice.self, ProductSchemaV1.VersionedProduct.self, Customer.self)
        } catch {
            print("Failed to initialize old model container. Assuming fresh install.")
            oldContainer = nil
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .environment(\.calendar, persianCalendar)
                .environment(\.locale, Locale(identifier: "fa"))
                .environment(storeManager)
                .onAppear {
                    storeManager.fetchAuthorizationStatus()
                }
                .task {
                    await performMigration()
                }
        }
    }

    @MainActor
    private func performMigration() async {
        // Check if we need to migrate old schema
        if let oldContainer = oldContainer {
            let migrationManager = DataMigrationManager(
                mainContainer: container,
                oldContainer: oldContainer
            )

            do {
                try await migrationManager.performMigrationIfNeeded()
            } catch {
                print("Old schema migration error: \(error)")
            }
        }
        
        // Always check for VAT/Discount conversion (for current schema)
        let vatDiscountConverter = VATDiscountConverter(container: container)
        do {
            try await vatDiscountConverter.convertVATDiscountToDecimal()
        } catch {
            print("VAT/Discount conversion error: \(error)")
        }
    }
}
