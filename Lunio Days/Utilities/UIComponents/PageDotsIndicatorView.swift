//
//  PageDotsIndicatorView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct PageDotsIndicatorView: View {

    let total: Int
    let selectedIndex: Int

    private let dotSize: CGFloat = 12
    private let spacing: CGFloat = 7

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(dotColor(for: index))
                    .frame(width: dotSize, height: dotSize)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page indicator")
        .accessibilityValue("\(selectedIndex + 1) of \(total)")
    }

    private func dotColor(for index: Int) -> Color {
        index == selectedIndex ? Color._111 : Color._111.opacity(0.4)
    }
}
