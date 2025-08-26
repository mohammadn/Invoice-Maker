//
//  StepperButtonView.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 18/08/2025.
//

import SwiftUI

struct StepperButtonView<Content: View>: View {
    private let scaleAnimationDuration: TimeInterval = 0.15
    private let opacityAnimationDuration: TimeInterval = 0.15
    private let fadeDelay: UInt64 = 150000000 // 0.15 seconds in nanoseconds

    let isPressed: Bool
    let content: Content

    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.0
    @State private var fadeTask: Task<Void, Never>?

    init(isPressed: Bool, @ViewBuilder content: () -> Content) {
        self.isPressed = isPressed
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundView)
            .onChange(of: isPressed, initial: false) { _, pressed in
                handlePressChange(pressed)
            }
    }

    private var backgroundView: some View {
        Color(.systemGray3)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(.easeInOut(duration: scaleAnimationDuration), value: scale)
    }

    private func handlePressChange(_ pressed: Bool) {
        fadeTask?.cancel()

        if pressed {
            withAnimation(.none) {
                opacity = 1.0
            }
            scale = 1.0
        } else {
            fadeTask = Task {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: opacityAnimationDuration)) {
                        opacity = 0.0
                    }
                }
                try? await Task.sleep(nanoseconds: fadeDelay)
                await MainActor.run {
                    guard !Task.isCancelled else { return }
                    scale = 0.9
                }
            }
        }
    }
}
