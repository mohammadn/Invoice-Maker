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
    @Query private var business: [Business]
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
        .onChange(of: selectedTab,initial: true) { _, _ in
            if business.isEmpty {
                selectedTab = .settings
            }
        }
    }
}

// #Preview {
//    ContentView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
