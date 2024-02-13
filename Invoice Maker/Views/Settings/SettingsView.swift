//
//  SettingsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var business: [Business]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("اطلاعات کسب و کار") {
                        if let business = business.first {
                            SettingsBusinessDetailsView(business: business)
                        }
                    }
                    .onAppear {
                        if business.isEmpty {
                            let business = Business(name: "",
                                                    address: "",
                                                    phone: "",
                                                    email: "",
                                                    website: "")
                            modelContext.insert(business)
                        }
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
        .modelContainer(previewContainer)
        .environment(\.layoutDirection, .rightToLeft)
}
