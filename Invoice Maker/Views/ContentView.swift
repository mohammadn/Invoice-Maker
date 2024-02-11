//
//  ContentView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

enum TabItems {
    case settings, products, invoices
}

struct ContentView: View {
    @State private var selectedTab: TabItems = .settings

    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem {
                    Label("تنظیمات", systemImage: "gearshape")
                }
            ProductsView()
                .tabItem {
                    Label("محصولات", systemImage: "list.dash")
                }
            Text("مشتریان")
                .tabItem {
                    Label("مشتریان", systemImage: "person.2")
                }
            Text("فاکتورها")
                .tabItem {
                    Label("فاکتورها", systemImage: "doc.text")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.layoutDirection, .rightToLeft)
}
