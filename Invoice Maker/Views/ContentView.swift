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
    @State private var selectedTab: TabItems = .settings

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
            Text("فاکتورها")
                .tabItem {
                    Label("فاکتورها", systemImage: "doc.text")
                }
                .tag(TabItems.invoices)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
