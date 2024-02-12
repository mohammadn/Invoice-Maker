//
//  SettingsBusinessDetailsView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 11/02/2024.
//

import SwiftUI

struct SettingsBusinessDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var website: String = ""
    @State private var logo: String = ""

    var body: some View {
        Form {
            Section {
                TextField("نام کسب و کار", text: $name)
            }

            Section {
                TextField("شماره تماس", text: $phoneNumber)
                TextField("آدرس", text: $address, axis: .vertical)
                    .lineLimit(3 ... 4)
            }

            Section {
                TextField("ایمیل", text: $email)
                TextField("وبسایت", text: $website)
            }

            Section {
                TextField("لوگو", text: $logo)
            }
        }
        .navigationTitle("اطلاعات کسب و کار")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("ذخیره") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsBusinessDetailsView()
            .environment(\.layoutDirection, .rightToLeft)
    }
}
