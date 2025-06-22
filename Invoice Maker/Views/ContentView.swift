//
//  ContentView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

enum TabItems: Hashable {
    case settings, products, customers, invoices
}

struct ContentView: View {
    @AppStorage("isWelcomeSheetShowing") var isWelcomeSheetShowing = true
    @Environment(\.modelContext) private var modelContext
    @Query private var business: [Business]
    @Query private var products: [Product]
    @State private var selectedTab: TabItems = .invoices

    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem {
                    Label("تنظیمات", systemImage: "gearshape")
                }
                .tag(TabItems.settings)
            ProductsView()
                .tabItem {
                    Label("محصولات", systemImage: "list.dash")
                }
                .tag(TabItems.products)
            CustomersView()
                .tabItem {
                    Label("مشتریان", systemImage: "person.2")
                }
                .tag(TabItems.customers)
            InvoicesView()
                .tabItem {
                    Label("فاکتورها", systemImage: "doc.text")
                }
                .tag(TabItems.invoices)
        }
        .sheet(isPresented: $isWelcomeSheetShowing) {
            OnboardingSheetView(business: business.first)
        }
        .onAppear {
            print(modelContext.sqliteCommand)
            
            products.forEach { product in
                let versionedProduct = VersionedProduct(from: product)
                modelContext.insert(versionedProduct)
                modelContext.delete(product)
            }
        }
    }
}

// #Preview {
//    ContentView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
