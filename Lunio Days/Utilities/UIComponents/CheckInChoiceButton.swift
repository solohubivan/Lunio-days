//
//  CheckInChoiceButton.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI

struct CheckInChoiceButton: View {

    let imageName: String
    let title: String
    let index: Int
    let selectedIndex: Int?
    let onSelect: (Int) -> Void

    private let accent = Color._111

    var body: some View {
        let isSelected = selectedIndex == index

        Button {
            onSelect(index)
        } label: {
            HStack(spacing: 12) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)

                Text(title)
                    .font(.phetsarath(.bold, size: 20))
                    .foregroundColor(isSelected ? accent : .brownText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? accent : .brownText, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        CheckInChoiceButton(
            imageName: "smile",
            title: "Good",
            index: 0,
            selectedIndex: 0,
            onSelect: { _ in }
        )

        CheckInChoiceButton(
            imageName: "sadSmile",
            title: "Bad",
            index: 1,
            selectedIndex: nil,
            onSelect: { _ in }
        )
    }
    .padding()
}
