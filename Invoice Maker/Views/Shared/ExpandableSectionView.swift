//
//  ExpandableSectionView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 02/07/2025.
//

import SwiftUI

struct ExpandableSectionView<BodyContent: View, HeaderContent: View>: View {
    @State var showSection: Bool = false

    @ViewBuilder let content: () -> BodyContent
    @ViewBuilder let header: () -> HeaderContent

    var body: some View {
        Section(isExpanded: $showSection) {
            content()
        } header: {
            HStack {
                header()

                Spacer()

                Button {
                    withAnimation {
                        showSection.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.subheadline)
                        .rotationEffect(.degrees(showSection ? 90 : 0))
                }
            }
        }
    }
}

// #Preview {
//    ExpandableSectionView()
// }
