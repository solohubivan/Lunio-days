//
//  OutlineButtonStyle.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct OutlineButtonStyle: ButtonStyle {

    let height: CGFloat = 56
    let cornerRadius: CGFloat = 57
    let strokeColor: Color = ._222

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.brownText)
        
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
