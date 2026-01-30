//
//  LastPeriodStartPickerView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct LastPeriodStartPickerView: View {

    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    
    var body: some View {
        VStack {
            titleLabel
            CustomDatePickerView(
                selectedDay: $selectedDay,
                selectedMonth: $selectedMonth
            )
            .padding(.vertical, 80)
        }
    }

    private var titleLabel: some View {
        Text(makeHighlightedText(
            fullText: "When did your last period start?",
            baseColor: .brownText,
            highlights: ["period": ._111])
        )
        .font(.petrona(.bold, size: 32))
        .foregroundColor(.brownText)
        .multilineTextAlignment(.center)
    }
}
