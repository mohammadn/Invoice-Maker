//
//  SettingsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("اطلاعات کسب و کار") {
                        Text("اطلاعات")
                    }
                }

                Section {
                    Button("امتیاز به ما", systemImage: "star") {
                    }

                    Button("اشتراک گذاری برنامه", systemImage: "square.and.arrow.up") {
                    }

                    Button("تماس با ما", systemImage: "envelope") {
                    }
                }
            }
            .navigationTitle("تنظیمات")
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.layoutDirection, .rightToLeft)
}
