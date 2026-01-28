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

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                LinearGradient(
                    colors: configuration.isPressed
                        ? [
                            Color._222.opacity(0.7),
                            Color._333.opacity(0.7)
                          ]
                        : [
                            Color._222,
                            Color._333
                          ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.buttonStateText)
            .cornerRadius(cornerRadius)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
