//
//  AvarageCycleDaysPickerView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct AvarageCycleDaysPickerView: View {

    @State private var selectedDurationIndex: Int = 0
    private let items: [String] = ["assd", "assd", "assd", "assd"]

    @State private var scrollTrigger: Int = 0

    var body: some View {
        VStack(spacing: 110) {
            titleLabel

            CustomWheelPicker(
                items: items,
                selectedIndex: $selectedDurationIndex,
                rowHeight: 26,
                visibleRows: 5,
                font: .phetsarath(.bold, size: 18),
                textColor: .brownText,
                selectedFont: .phetsarath(.bold, size: 24),
                selectedColor: .black,
                dimmedOpacity: 0.25,
                scrollTrigger: scrollTrigger
            )
            .frame(width: 200)
        }
        .onAppear {
            DispatchQueue.main.async {
                selectedDurationIndex = 5
                scrollTrigger += 1
            }
        }
    }

    private var titleLabel: some View {
        Text("How many days is your average cycle?")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    AvarageCycleDaysPickerView()
}
