//
//  StepperButtonStyle.swift
//  Invoice Maker
//
//  Created by Mohammad Najafzadeh on 18/08/2025.
//

import SwiftUI

struct StepperButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        StepperButtonView(isPressed: configuration.isPressed) {
            configuration.label
        }
    }
}
