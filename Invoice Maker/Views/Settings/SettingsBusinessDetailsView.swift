//
//  SettingsBusinessDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftData
import SwiftUI

struct SettingsBusinessDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var businessDetails: BusinessDetails
    @State private var logo: String = ""

    var business: Business

    init(business: Business) {
        self.business = business
        _businessDetails = State(initialValue: BusinessDetails(from: business))
    }

    var body: some View {
        Form {
            Section {
                TextField("نام کسب و کار", text: $businessDetails.name)
            }

            Section {
                TextField("شماره تماس", text: $businessDetails.phone)
                TextField("آدرس", text: $businessDetails.address, axis: .vertical)
                    .lineLimit(3 ... 5)
            }

            Section {
                TextField("ایمیل", text: $businessDetails.email)
                TextField("وبسایت", text: $businessDetails.website)
            }

            Section {
                TextField("لوگو", text: $logo)
            }
        }
        .navigationTitle("اطلاعات کسب و کار")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("ذخیره") {
                    business.update(with: businessDetails)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

    let container = try! ModelContainer(for: Business.self,
                                        configurations: configuration)
    return NavigationStack {
        SettingsBusinessDetailsView(business: Business.sampleData)
    }
    .modelContainer(container)
    .environment(\.layoutDirection, .rightToLeft)
}
