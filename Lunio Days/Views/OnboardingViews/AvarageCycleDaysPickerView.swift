//
//  AvarageCycleDaysPickerView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct AvarageCycleDaysPickerView: View {

    @State private var selectedDurationIndex: Int = 0
    private let items: [String] = ["< 21", "21-25", "26-30", "31-35", "35 +"]

    @State private var scrollTrigger: Int = 0

    var body: some View {
        VStack {
            titleLabel

            ZStack {
                Color.datePickerGray
                    .frame(height: 25)
                    .cornerRadius(4)
                
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
            }
            .padding(.vertical, 80)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            DispatchQueue.main.async {
                selectedDurationIndex = 2
                scrollTrigger += 1
            }
        }
    }

    private var titleLabel: some View {
        Text(makeHighlightedText(
            fullText: "How many days is your average cycle?",
            baseColor: .brownText,
            highlights: ["days": ._111]))
            .font(.petrona(.bold, size: 32))
            .multilineTextAlignment(.center)
    }
}

#Preview {
    AvarageCycleDaysPickerView()
}
