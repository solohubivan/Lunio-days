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
        VStack(spacing: 110) {
            titleLabel
            CustomDatePickerView(
                selectedDay: $selectedDay,
                selectedMonth: $selectedMonth
            )
        }
    }

    private var titleLabel: some View {
        Text("When did your last period start?")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
    }
}

//#Preview {
//    LastPeriodStartPickerView(selectedDay: 5, selectedMonth: )
//}
