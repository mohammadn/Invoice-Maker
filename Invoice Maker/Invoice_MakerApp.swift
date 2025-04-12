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
    var persianCalendar: Calendar {
        var calendar = Calendar(identifier: .persian)
        calendar.firstWeekday = 7
        return calendar
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Business.self, Invoice.self, StandaloneInvoice.self, Product.self, Customer.self])
                .environment(\.calendar, persianCalendar)
                .environment(\.locale, Locale(identifier: "fa"))
                .environment(storeManager)
                .onAppear {
                    storeManager.fetchAuthorizationStatus()
                }
        }
    }
}
