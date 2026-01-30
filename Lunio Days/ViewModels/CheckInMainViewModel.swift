//
//  CheckInMainViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import CoreData
import Combine

final class CheckInMainViewModel: ObservableObject {

    @Published private(set) var isTodayCheckInCompleted: Bool = false
    @Published var showFlow: Bool = false

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
        reloadTodayCheckInState()
    }

    func onBecameActive() {
        reloadTodayCheckInState()
    }

    func onFlowDismiss() {
        reloadTodayCheckInState()
    }

    func startCheckInTapped() {
        guard !isTodayCheckInCompleted else { return }
        showFlow = true
    }

    private func reloadTodayCheckInState() {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)
            let today = calendar.startOfDay(for: Date())

            let record = try manager.fetchRecord(for: today)

            if let record {
                isTodayCheckInCompleted = (record.mood != -1 && record.painLevel != -1 && record.energy != -1)
            } else {
                isTodayCheckInCompleted = false
            }
        } catch {
            isTodayCheckInCompleted = false
        }
    }
}
