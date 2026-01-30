//
//  FullWidthButtonStyle.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct FullWidthButtonStyle: ButtonStyle {
    
    var cornerRadius: CGFloat = 57
    var height: CGFloat = 56
    var backgroundColor: Color? = nil
    var gradientTextColor: Color = .buttonStateText
    var solidTextColor: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(backgroundView(isPressed: configuration.isPressed))
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }

    private var textColor: Color {
        backgroundColor == nil ? gradientTextColor : solidTextColor
    }

    @ViewBuilder
    private func backgroundView(isPressed: Bool) -> some View {
        if let backgroundColor {
            backgroundColor.opacity(isPressed ? 0.7 : 1.0)
        } else {
            LinearGradient(
                colors: isPressed
                    ? [Color._222.opacity(0.7), Color._333.opacity(0.7)]
                    : [Color._222, Color._333],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}
