//
//  DayRecordsManager.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 29.01.2026.
//

import Foundation
import CoreData

final class DayRecordsManager {

    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(context: NSManagedObjectContext, calendar: Calendar = .current) {
        self.context = context
        self.calendar = calendar
    }
    
    
    func fetchCheckInDays(in range: ClosedRange<Date>) throws -> Set<Date> {
        let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()

        let start = normalize(range.lowerBound)
        let endExclusive = calendar.date(byAdding: .day, value: 1, to: normalize(range.upperBound))!

        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@ AND mood != -1 AND painLevel != -1 AND energy != -1",
            start as NSDate,
            endExclusive as NSDate
        )

        request.returnsObjectsAsFaults = false
        let results = try context.fetch(request)

        return Set(results.compactMap { $0.date }.map(normalize))
    }
    
    func saveCheckInForToday(mood: Mood, pain: PainLevel, energy: EnergyLevel) throws {
        let today = normalize(Date())
        let record = try fetchOrCreateRecord(for: today)

        record.mood = mood.rawValue
        record.painLevel = pain.rawValue
        record.energy = energy.rawValue

        try context.save()
    }
    
    // MARK: - Updates

    func setPeriodDay(for date: Date, isPeriodDay: Bool) throws {
        let normalized = normalize(date)

        if let record = try fetchRecord(for: normalized) {
            record.isPeriodDay = isPeriodDay
            if record.date == nil { record.date = normalized }
        } else {
            let record = DayRecord(context: context)
            record.date = normalized
            record.isPeriodDay = isPeriodDay
        }

        try context.save()
    }
    
    func clearFuturePeriodDays(from fromDate: Date) throws {
        let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()

        let start = normalize(fromDate)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: start)!

        request.predicate = NSPredicate(format: "date >= %@ AND isPeriodDay == YES", tomorrow as NSDate)

        let results = try context.fetch(request)
        results.forEach { $0.isPeriodDay = false }

        try context.save()
    }
    
    func fetchPeriodDays(in range: ClosedRange<Date>) throws -> Set<Date> {
        let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()

        let start = normalize(range.lowerBound)
        let endExclusive = calendar.date(byAdding: .day, value: 1, to: normalize(range.upperBound))!

        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@ AND isPeriodDay == YES",
            start as NSDate,
            endExclusive as NSDate
        )

        request.returnsObjectsAsFaults = false

        let results = try context.fetch(request)
        return Set(results.compactMap { $0.date }.map(normalize))
    }

    func saveInitialPeriodDays(lastPeriodStarted: Date, durationDays: Int) throws {
        guard durationDays > 0 else { return }

        let start = normalize(lastPeriodStarted)

        for offset in 0..<durationDays {
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else { continue }
            let normalizedDate = normalize(date)

            if try fetchRecord(for: normalizedDate) != nil {
                continue
            }

            let record = DayRecord(context: context)
            record.date = normalizedDate
            record.isPeriodDay = true
        }

        try context.save()
    }

    func fetchRecord(for date: Date) throws -> DayRecord? {
        let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
        request.fetchLimit = 1

        let start = normalize(date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)

        return try context.fetch(request).first
    }

    func normalize(_ date: Date) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
    }
    
    private func fetchOrCreateRecord(for date: Date) throws -> DayRecord {
        let normalized = normalize(date)

        if let existing = try fetchRecord(for: normalized) {
            if existing.date == nil { existing.date = normalized }
            return existing
        }

        let record = DayRecord(context: context)
        record.date = normalized
        
        record.mood = -1
        record.painLevel = -1
        record.energy = -1
        record.isPeriodDay = false

        return record
    }
}
