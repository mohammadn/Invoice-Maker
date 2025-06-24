//
//  SettingsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

struct SettingsView: View {
    @AppStorage("defaultCurrency") var defaultCurrencyRawValue: String = Currency.IRR.rawValue
    @Environment(\.openURL) var openURL
    @Query private var business: [Business]
    private var defaultCurrency: Binding<Currency> {
        Binding<Currency>(
            get: { Currency(rawValue: defaultCurrencyRawValue) ?? .IRR },
            set: { defaultCurrencyRawValue = $0.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("اطلاعات کسب و کار") {
                        NavigationLazyView(SettingsBusinessDetailsView(business: business.first))
                    }
                }

                Section("پیش‌ فرض‌") {
                    Picker("نوع ارز", selection: defaultCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.label).tag(currency)
                        }
                    }
                }

                Section {
                    Button("امتیاز به ما", systemImage: "star") {
                        if let url = URL(string: "itms-apps://apps.apple.com/app/id6738891697?action=write-review") {
                            openURL(url)
                        }
                    }

                    ShareLink(item: URL(string: "https://apple.co/4j6DlPl")!) {
                        Label("اشتراک گذاری برنامه", systemImage: "square.and.arrow.up")
                    }

                    Button("تماس با ما", systemImage: "envelope") {
                        if let url = URL(string: "mailto:mohammadnajafzade@yahoo.com?subject=Invoice Maker") {
                            openURL(url)
                        }
                    }

                    Button("تلگرام", systemImage: "paperplane") {
                        if let url = URL(string: "tg://resolve?domain=invoicemaker") {
                            openURL(url)
                        }
                    }
                }
            }
            .navigationTitle("تنظیمات")
        }
    }
}

// #Preview {
//    SettingsView()
//        .modelContainer(previewContainer)
//        .environment(\.layoutDirection, .rightToLeft)
// }
