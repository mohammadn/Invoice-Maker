//
//  ContentView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @AppStorage("isWelcomeSheetShowing") var isWelcomeSheetShowing = true
    @Environment(\.modelContext) private var modelContext
    @Query private var business: [Business]
    @Query private var products: [Product]
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
