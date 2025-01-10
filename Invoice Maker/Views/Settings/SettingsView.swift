//
//  SettingsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import StoreKit
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
    @Environment(\.requestReview) private var requestReview
    @Environment(\.openURL) var openURL
    @Query private var business: [Business]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("اطلاعات کسب و کار") {
                        NavigationLazyView(SettingsBusinessDetailsView(business: business.first))
                    }
                } footer: {
                    if business.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                            Text("لطفا اطلاعات کسب و کار خود را وارد نمایید.")
                        }
                    }
                }

                Section {
                    Button("امتیاز به ما", systemImage: "star") {
                        requestReview()
                    }

                    ShareLink(item: URL(string: "https://apple.co/4j6DlPl")!) {
                        Label("اشتراک گذاری برنامه", systemImage: "square.and.arrow.up")
                    }

                    Button("تماس با ما", systemImage: "envelope") {
                        openURL(URL(string: "mailto:mohammadnajafzade@yahoo.com?subject=Invoice Maker")!)
                    }

                    Button("تلگرام", systemImage: "paperplane") {
                        openURL(URL(string: "tg://resolve?domain=invoicemaker")!)
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
