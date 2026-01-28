//
//  PeriodsDurationPickerView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct PeriodsDurationPickerView: View {

    @State private var selectedDurationIndex: Int = 0
    private let dayItems: [String] = (1...14).map(String.init)

    @State private var scrollTrigger: Int = 0

    var body: some View {
        VStack(spacing: 110) {
            titleLabel

            CustomWheelPicker(
                items: dayItems,
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
            .frame(width: 30)
        }
        .onAppear {
            DispatchQueue.main.async {
                selectedDurationIndex = 5
                scrollTrigger += 1
            }
        }
    }

    private var titleLabel: some View {
        Text("How many days do your periods ussually last?")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    PeriodsDurationPickerView()
}
