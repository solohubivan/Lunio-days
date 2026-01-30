//
//  HomeScreenViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import CoreData
import Combine

// MARK: - ViewModel

final class HomeScreenViewModel: ObservableObject {

    @Published private(set) var calendarRefreshTrigger: Int = 0
    @Published private(set) var isTodayPeriodDay: Bool = false
    @Published private(set) var isTodayCheckInCompleted: Bool = false

    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(
        context: NSManagedObjectContext,
        calendar: Calendar = .current
    ) {
        self.context = context
        self.calendar = calendar
    }

    var formattedTodayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }

    func onAppear(session: UserSession) {
        syncTodayIfNeeded(session: session)
    }

    func onBecameActive(session: UserSession) {
        syncTodayIfNeeded(session: session)
    }

    func startPeriodToday(session: UserSession) {
        do {
            session.startPeriod()
            let manager = DayRecordsManager(context: context, calendar: calendar)
            try manager.setPeriodDay(for: Date(), isPeriodDay: true)

            isTodayPeriodDay = true
            bumpCalendar()
        } catch {
            // залишаємо як є (без алертів)
        }
    }

    func endPeriodToday(session: UserSession) {
        do {
            session.stopPeriod()
            let manager = DayRecordsManager(context: context, calendar: calendar)
            try manager.setPeriodDay(for: Date(), isPeriodDay: false)
            try manager.clearFuturePeriodDays(from: Date())

            isTodayPeriodDay = false
            bumpCalendar()
        } catch {
            // залишаємо як є (без алертів)
        }
    }

    // MARK: - Private

    private func syncTodayIfNeeded(session: UserSession) {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)

            if session.user.periodDay {
                try manager.setPeriodDay(for: Date(), isPeriodDay: true)
            }

            reloadTodayState()
            reloadTodayCheckInState()
            bumpCalendar()
        } catch {
            reloadTodayState()
            reloadTodayCheckInState()
            bumpCalendar()
        }
    }

    private func reloadTodayCheckInState() {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)
            let today = calendar.startOfDay(for: Date())

            if let record = try manager.fetchRecord(for: today) {
                isTodayCheckInCompleted = (record.mood >= 0 && record.painLevel >= 0 && record.energy >= 0)
            } else {
                isTodayCheckInCompleted = false
            }
        } catch {
            isTodayCheckInCompleted = false
        }
    }

    private func reloadTodayState() {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)
            let today = calendar.startOfDay(for: Date())
            let record = try manager.fetchRecord(for: today)
            isTodayPeriodDay = record?.isPeriodDay ?? false
        } catch {
            isTodayPeriodDay = false
        }
    }

    private func bumpCalendar() {
        calendarRefreshTrigger += 1
    }
}
