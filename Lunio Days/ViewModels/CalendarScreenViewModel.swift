//
//  CalendarScreenViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import Foundation
import CoreData
import SwiftUI
import Combine

@MainActor
final class CalendarScreenViewModel: ObservableObject {

    // MARK: - Published state (UI reads)
    @Published var isBottomExpanded: Bool = false

    @Published var currentPage: Date = Date()
    @Published var periodDays: Set<Date> = []
    @Published var checkInDays: Set<Date> = []
    @Published var selectedDayRecord: DayRecord?

    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(
        context: NSManagedObjectContext,
        calendar: Calendar = .current
    ) {
        self.context = context
        self.calendar = calendar
    }

    // MARK: - Lifecycle
    func onAppear(selectedDate: Date) {
        currentPage = selectedDate
        loadAllPeriodDays()
        loadAllCheckInDays()
        loadSelectedDayRecord(for: selectedDate)
    }

    func onSelectedDateChanged(_ date: Date) {
        currentPage = date
        loadSelectedDayRecord(for: date)
    }

    // MARK: - UI intents
    func toggleBottomExpanded() {
        isBottomExpanded.toggle()
    }

    func changeMonth(by value: Int) {
        guard let newDate = calendar.date(byAdding: .month, value: value, to: currentPage) else { return }
        currentPage = newDate
    }

    // MARK: - Derived UI state
    func isPeriodSelectedDay(selectedDate: Date) -> Bool {
        let normalized = normalize(selectedDate)
        return periodDays.contains(normalized)
    }

    func isTodaySelected(selectedDate: Date) -> Bool {
        calendar.isDate(selectedDate, inSameDayAs: Date())
    }

    func isCheckInSelectedDay(selectedDate: Date) -> Bool {
        let normalized = normalize(selectedDate)
        return checkInDays.contains(normalized)
    }

    func shouldShowCycleOrPeriodLabel(selectedDate: Date) -> Bool {
        if isPeriodSelectedDay(selectedDate: selectedDate) { return true }
        return !isFutureSelectedDay(selectedDate: selectedDate)
    }

    private func isFutureSelectedDay(selectedDate: Date) -> Bool {
        let selectedStart = calendar.startOfDay(for: selectedDate)
        let todayStart = calendar.startOfDay(for: Date())
        return selectedStart > todayStart
    }

    // MARK: - CoreData loads
    func loadSelectedDayRecord(for selectedDate: Date) {
        do {
            let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()

            let start = calendar.startOfDay(for: selectedDate)
            let end = calendar.date(byAdding: .day, value: 1, to: start)!

            request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            request.fetchLimit = 1
            request.returnsObjectsAsFaults = false

            selectedDayRecord = try context.fetch(request).first
        } catch {
            selectedDayRecord = nil
        }
    }

    func loadAllCheckInDays() {
        do {
            let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
            request.predicate = NSPredicate(
                format: "date != nil AND mood != -1 AND painLevel != -1 AND energy != -1"
            )
            request.returnsObjectsAsFaults = false

            let results = try context.fetch(request)
            checkInDays = Set(results.compactMap { $0.date }.map(normalize))
        } catch {
            checkInDays = []
        }
    }

    func loadAllPeriodDays() {
        do {
            let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
            request.predicate = NSPredicate(format: "isPeriodDay == YES AND date != nil")
            request.returnsObjectsAsFaults = false

            let results = try context.fetch(request)
            periodDays = Set(results.compactMap { $0.date }.map(normalize))
        } catch {
            periodDays = []
        }
    }

    // MARK: - Utils
    func normalize(_ date: Date) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
    }
}
