//
//  InputStepper.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 18/08/2025.
//

import SwiftUI

struct InputStepper<Label: View>: View {
    @Binding var value: Decimal
    let minimumValue: Decimal
    let label: Label

    private let buttonSize = CGSize(width: 48, height: 34)
    private let textFieldWidth: CGFloat = 58
    private let dividerPadding: CGFloat = 8
    private let cornerRadius: CGFloat = 8

    init(value: Binding<Decimal>, minimumValue: Decimal = 1, @ViewBuilder label: () -> Label) {
        _value = value
        self.minimumValue = minimumValue
        self.label = label()
    }

    var body: some View {
        HStack {
            label
            Spacer()
            stepperControls
        }
        .padding(.vertical, 2)
        .lineLimit(1)
    }

    private var stepperControls: some View {
        HStack(spacing: 0) {
            incrementButton
            divider
            valueTextField
            divider
            decrementButton
        }
        .background(Color(.secondarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .frame(height: buttonSize.height)
    }

    private var incrementButton: some View {
        Button(action: incrementValue) {
            Image(systemName: "plus")
        }
        .frame(width: buttonSize.width, height: buttonSize.height)
        .foregroundColor(.primary)
        .contentShape(Rectangle())
        .buttonStyle(StepperButtonStyle())
    }

    private var decrementButton: some View {
        Button(action: decrementValue) {
            Image(systemName: "minus")
        }
        .frame(width: buttonSize.width, height: buttonSize.height)
        .foregroundColor(canDecrement ? .primary : Color(.tertiaryLabel))
        .contentShape(Rectangle())
        .buttonStyle(StepperButtonStyle())
        .disabled(!canDecrement)
    }

    private var valueTextField: some View {
        TextField("", value: $value, format: .number.precision(.fractionLength(0...2)))
            .multilineTextAlignment(.center)
            .foregroundColor(.primary)
            .frame(width: textFieldWidth, height: buttonSize.height)
            .keyboardType(.decimalPad)
    }

    private var divider: some View {
        Divider().padding(.vertical, dividerPadding)
    }

    private var canDecrement: Bool {
        value > minimumValue
    }

    private func incrementValue() {
        value += 1
    }

    private func decrementValue() {
        guard canDecrement else { return }
        value = max(minimumValue, value - 1)
    }
}
