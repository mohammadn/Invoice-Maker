//
//  ButtonWithPopover.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 22/05/2025.
//

import SwiftUI

struct ButtonWithPopover: View {
    @State var show: Bool = false

    let text: String
    let action: () -> Void

    var body: some View {
        Button {
            show.toggle()
        } label: {
            Image(systemName: "exclamationmark.circle")
        }
        .popover(isPresented: $show, arrowEdge: .bottom) {
            Group {
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 20)

                Button("بروزرسانی") {
                    action()

                    show.toggle()
                }
            }
            .padding(20)
            .presentationCompactAdaptation(.popover)
        }
    }
}
