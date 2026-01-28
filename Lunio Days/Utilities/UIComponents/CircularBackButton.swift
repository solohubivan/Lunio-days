//
//  CircularBackButton.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct CircularBackButton: View {

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                LinearGradient(
                    colors: [Color._222, Color._333],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color.buttonStateText)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            .shadow(
                color: .black.opacity(0.25),
                radius: 4,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CircularBackButton {
        print("Back tapped")
    }
}
