//
//  CustomDatePickerView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//
import SwiftUI

struct CustomDatePickerView: View {
    
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int

    private let monthItems: [String] = Month.allCases.map { $0.title }
    @State private var dayItems: [String] = (1...Month.january.daysCount).map(String.init)

    @State private var dayScrollTrigger: Int = 0

    var body: some View {
        ZStack {
            Color.datePickerGray
                .frame(height: 25)
                .cornerRadius(4)
            
            HStack(alignment: .center) {
                
                CustomWheelPicker(
                    items: dayItems,
                    selectedIndex: $selectedDay,
                    rowHeight: 26,
                    visibleRows: 5,
                    font: .phetsarath(.bold, size: 18),
                    textColor: .brownText,
                    selectedFont: .phetsarath(.bold, size: 24),
                    selectedColor: .black,
                    dimmedOpacity: 0.25,
                    scrollTrigger: dayScrollTrigger
                )
                .frame(width: 30)
                
                CustomWheelPicker(
                    items: monthItems,
                    selectedIndex: $selectedMonth,
                    rowHeight: 26,
                    visibleRows: 5,
                    font: .phetsarath(.bold, size: 18),
                    textColor: .brownText,
                    selectedFont: .phetsarath(.bold, size: 24),
                    selectedColor: .black,
                    dimmedOpacity: 0.25
                )
                .frame(width: 150)
            }
        }
        .onAppear {
            let calendar = Calendar.current
            let today = Date()

            let monthIndex = calendar.component(.month, from: today) - 1
            let dayIndex = calendar.component(.day, from: today) - 1

            selectedMonth = clamp(monthIndex, 0, Month.allCases.count - 1)
            syncDaysForMonth(selectedMonth)

            let maxDayIndex = max(dayItems.count - 1, 0)
            selectedDay = clamp(dayIndex, 0, maxDayIndex)

            dayScrollTrigger += 1
        }
        .onChange(of: selectedMonth) { newMonthIndex in
            syncDaysForMonth(newMonthIndex)
        }
    }

    private func syncDaysForMonth(_ monthIndex: Int) {
        let month = Month.allCases[clamp(monthIndex, 0, Month.allCases.count - 1)]
        let newDays = (1...month.daysCount).map(String.init)

        dayItems = newDays

        let maxDayIndex = max(newDays.count - 1, 0)
        if selectedDay > maxDayIndex { selectedDay = maxDayIndex }
        if selectedDay < 0 { selectedDay = 0 }

        dayScrollTrigger += 1
    }

    private func clamp(_ value: Int, _ min: Int, _ max: Int) -> Int {
        Swift.max(min, Swift.min(max, value))
    }
}

//#Preview {
//    CustomDatePickerView()
//}
