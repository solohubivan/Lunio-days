//
//  WeekCalendarViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import CoreData
import Combine

final class WeekCalendarViewModel: ObservableObject {

    @Published private(set) var periodDays: Set<Date> = []
    @Published private(set) var checkInDays: Set<Date> = []

    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(
        context: NSManagedObjectContext,
        calendar: Calendar = .current
    ) {
        self.context = context
        self.calendar = calendar
    }

    func onAppear() {
        fetchWeek()
    }

    func onRefreshTriggerChanged() {
        fetchWeek()
    }

    func onDayChanged() {
        fetchWeek()
    }

    func weekdayTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).lowercased()
    }

    func isPeriodDay(_ date: Date) -> Bool {
        periodDays.contains(normalize(date))
    }

    func hasCheckIn(_ date: Date) -> Bool {
        checkInDays.contains(normalize(date))
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func dateForOffset(_ offset: Int) -> Date {
        calendar.date(byAdding: .day, value: offset, to: Date()) ?? Date()
    }

    func dayNumber(from date: Date) -> Int {
        calendar.component(.day, from: date)
    }

    private func fetchWeek() {
        do {
            let start = calendar.startOfDay(
                for: calendar.date(byAdding: .day, value: -3, to: Date()) ?? Date()
            )
            let end = calendar.startOfDay(
                for: calendar.date(byAdding: .day, value: 3, to: Date()) ?? Date()
            )

            let manager = DayRecordsManager(context: context, calendar: calendar)
            periodDays = try manager.fetchPeriodDays(in: start...end)
            checkInDays = try manager.fetchCheckInDays(in: start...end)
        } catch {
            periodDays = []
            checkInDays = []
        }
    }

    private func normalize(_ date: Date) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
    }
}
