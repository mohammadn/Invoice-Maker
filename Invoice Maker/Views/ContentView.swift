//
//  ContentView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import CloudKit
import SwiftData
import SwiftUI

@MainActor
enum ICloudKVS {
    static let store = NSUbiquitousKeyValueStore.default
    static let isWelcomeKey = "isWelcomeSheetShowing"

    static func setIsWelcomeSheetShowing(_ value: Bool) {
        store.set(value, forKey: isWelcomeKey)
        store.synchronize() // Push changes to iCloud
    }

    static func getIsWelcomeSheetShowing() -> Bool {
        // Provide a sensible default if not present
        return store.object(forKey: isWelcomeKey) as? Bool ?? true
    }
}

struct ContentView: View {
    @AppStorage("isWelcomeSheetShowing") var isWelcomeSheetShowing = true
    @Environment(\.modelContext) private var modelContext
    @Query private var business: [BusinessN]
    @State private var tabViewModel = TabViewModel()
    @State private var invoiceViewModel = InvoiceViewModel()

    var body: some View {
        TabView(selection: $tabViewModel.selectedTab) {
            SettingsView()
                .tabItem {
                    Label("تنظیمات", systemImage: "gearshape")
                }
                .tag(TabViewModel.Tabs.settings)
            ProductsView()
                .tabItem {
                    Label("محصولات", systemImage: "list.dash")
                }
                .tag(TabViewModel.Tabs.products)
            CustomersView()
                .tabItem {
                    Label("مشتریان", systemImage: "person.2")
                }
                .tag(TabViewModel.Tabs.customers)
            InvoicesView()
                .tabItem {
                    Label("فاکتورها", systemImage: "doc.text")
                }
                .tag(TabViewModel.Tabs.invoices)
        }
        .environment(tabViewModel)
        .environment(invoiceViewModel)
        .sheet(isPresented: $isWelcomeSheetShowing) {
            OnboardingSheetView(business: business.first)
        }
        .onAppear {
            let cloudValue = ICloudKVS.getIsWelcomeSheetShowing()
            if isWelcomeSheetShowing != cloudValue {
                isWelcomeSheetShowing = cloudValue
            }
        }
        .onChange(of: isWelcomeSheetShowing) { _, newValue in
            ICloudKVS.setIsWelcomeSheetShowing(newValue)
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var storeManager = ContactStoreManager()
        var persianCalendar: Calendar {
            var calendar = Calendar(identifier: .persian)
            calendar.firstWeekday = 7
            return calendar
        }

        ContentView()
            .modelContainer(previewContainer)
            .environment(\.calendar, persianCalendar)
            .environment(\.locale, Locale(identifier: "fa"))
            .environment(storeManager)
    }
#endif
