//
//  Invoice_MakerApp.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

@main
struct Invoice_MakerApp: App {
    @State private var storeManager = ContactStoreManager()

    private let container: ModelContainer
    private var persianCalendar: Calendar {
        var calendar = Calendar(identifier: .persian)
        calendar.firstWeekday = 7
        return calendar
    }

    init() {
        do {
            container = try ModelContainer(for: Business.self, Invoice.self, VersionedInvoice.self, Product.self, VersionedProduct.self, Customer.self, migrationPlan: MigrationPlan.self)
        } catch {
            fatalError("Failed to initialize model container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .environment(\.calendar, persianCalendar)
//                .environment(\.locale, Locale(identifier: "fa"))
                .environment(storeManager)
                .onAppear {
                    storeManager.fetchAuthorizationStatus()
                    
              
                }
        }
    }
}
