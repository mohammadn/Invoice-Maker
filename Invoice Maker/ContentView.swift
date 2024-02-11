//
//  ContentView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("فاکتورها")
                .tabItem {
                    Label("فاکتورها", systemImage: "doc.text")
                }
            Text("محصولات")
                .tabItem {
                    Label("محصولات", systemImage: "list.dash")
                }
            Text("تنظیمات")
                .tabItem {
                    Label("تنظیمات", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.layoutDirection, .rightToLeft)
}
