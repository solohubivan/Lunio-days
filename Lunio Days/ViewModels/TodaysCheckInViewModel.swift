//
//  TodaysCheckInViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import CoreData
import Combine

final class TodaysCheckInViewModel: ObservableObject {

    @Published private(set) var mood: Mood?
    @Published private(set) var pain: PainLevel?
    @Published private(set) var energy: EnergyLevel?

    private let context: NSManagedObjectContext
    private let calendar: Calendar

    init(
        context: NSManagedObjectContext,
        calendar: Calendar = .current
    ) {
        self.context = context
        self.calendar = calendar
    }

    var hasData: Bool {
        mood != nil && pain != nil && energy != nil
    }

    func loadToday() {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)
            let today = calendar.startOfDay(for: Date())

            guard let record = try manager.fetchRecord(for: today) else {
                setEmpty()
                return
            }

            mood = Mood(rawOrNil: record.mood)
            pain = PainLevel(rawOrNil: record.painLevel)
            energy = EnergyLevel(rawOrNil: record.energy)

        } catch {
            setEmpty()
        }
    }

    func todayStartOfDay() -> Date {
        calendar.startOfDay(for: Date())
    }

    private func setEmpty() {
        mood = nil
        pain = nil
        energy = nil
    }
}
