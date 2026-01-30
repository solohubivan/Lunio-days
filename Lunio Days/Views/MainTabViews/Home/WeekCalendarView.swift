//
//  WeekCalendarView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI
import CoreData

struct WeekCalendarView: View {

    @Environment(\.managedObjectContext) private var context

    private let calendar = Calendar.current
    
    @Binding var selectedTab: Int              // ✅
        @Binding var calendarSelectedDate: Date

    @State private var periodDays: Set<Date> = []
    @State private var checkInDays: Set<Date> = []

    let refreshTrigger: Int

    var body: some View {
        HStack(spacing: 4) {
            Spacer()

            ForEach(0..<7, id: \.self) { index in
                let offset = index - 3
                dayCell(for: offset, isToday: offset == 0)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(8)
        .onAppear { fetchWeek() }
        .onChange(of: refreshTrigger) { _ in fetchWeek() }
        .onChange(of: calendar.startOfDay(for: Date())) { _ in fetchWeek() }
    }

    private func fetchWeek() {
        do {
            let start = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -3, to: Date()) ?? Date())
            let end   = calendar.startOfDay(for: calendar.date(byAdding: .day, value:  3, to: Date()) ?? Date())

            let manager = DayRecordsManager(context: context, calendar: calendar)

            periodDays  = try manager.fetchPeriodDays(in: start...end)
            checkInDays = try manager.fetchCheckInDays(in: start...end)
            
        } catch {
            periodDays = []
            checkInDays = []
        }
    }

    // MARK: - Helpers

    private func normalize(_ date: Date) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
    }

    private func hasCheckIn(date: Date) -> Bool {
        checkInDays.contains(normalize(date))
    }

    private func isPeriodDay(date: Date) -> Bool {
        periodDays.contains(normalize(date))
    }

    private func weekdayTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).lowercased()
    }

    // MARK: - Cell

    private func dayCell(for offset: Int, isToday: Bool) -> some View {
        let date = calendar.date(byAdding: .day, value: offset, to: Date()) ?? Date()
        let dayNumber = calendar.component(.day, from: date)

        let showDot = hasCheckIn(date: date)
        let isPeriod = isPeriodDay(date: date)

        let backgroundColor: Color = isPeriod ? (isToday ? ._11 : ._111) : .white
        let numberColor: Color = isPeriod ? (isToday ? .black : .white) : (isToday ? ._111 : .black)
        let weekdayColor: Color = isPeriod ? (isToday ? .black : ._111) : (isToday ? ._111 : .black)
        let borderLine: Color = (isToday && !isPeriod) ? ._111 : .clear
        
        let checkInPoint: Color = isPeriod ? (isToday ? .clear : .white) : (isToday ? .clear : ._111)

        return VStack(spacing: 0) {
            Text(weekdayTitle(from: date))
                .font(.phetsarath(.regular, size: 12))
                .foregroundColor(weekdayColor)

            ZStack {
                Text("\(dayNumber)")
                    .font(.phetsarath(.regular, size: 16))
                    .foregroundColor(numberColor)
                    .frame(width: 44, height: 44)
                    .background(backgroundColor)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(borderLine, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)

                if showDot {
                    VStack {
                        Circle()
                            .fill(checkInPoint)
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle()) // ✅ щоб тапався весь блок
            .onTapGesture {
                calendarSelectedDate = date   // ✅ яку дату вибрали у week view
                selectedTab = 1              // ✅ переключились на таб календаря
            }
    }
}
