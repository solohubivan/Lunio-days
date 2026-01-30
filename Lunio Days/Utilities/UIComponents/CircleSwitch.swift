//
//  CircleSwitch.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct CircleSwitch: View {

    @Binding var isOn: Bool

    var height: CGFloat = 44
    var width: CGFloat = 72

    private var knobSize: CGFloat { height - 9 }
    private var padding: CGFloat { (height - knobSize) / 2 }

    private var onBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color._222,
                Color._333
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var offBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.4),
                Color.gray.opacity(0.3)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.22, dampingFraction: 0.85)) {
                isOn.toggle()
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(isOn ? AnyShapeStyle(onBackgroundGradient) : AnyShapeStyle(offBackgroundGradient))
                    .frame(width: width, height: height)
                Circle()
                    .fill(Color.white)
                    .frame(width: knobSize, height: knobSize)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                    .padding(padding)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CircleSwitch(isOn: .constant(true))
}
