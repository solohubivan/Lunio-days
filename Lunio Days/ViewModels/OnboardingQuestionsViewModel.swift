//
//  OnboardingQuestionsViewModel.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import CoreData
import Combine

final class OnboardingQuestionsViewModel: ObservableObject {

    @Published var showMainTab: Bool = false
    @Published var pageIndex: Int = 0
    @Published var selectedDay: Int = 0
    @Published var selectedMonth: Int = 0
    @Published var selectedDurationIndex: Int = 3

    var isLastPage: Bool { pageIndex == 2 }
    var nextButtonTitle: String { isLastPage ? "Finish" : "Next" }

    func onNextTap(
        context: NSManagedObjectContext,
        session: UserSession,
        setHasCompletedOnboarding: (Bool) -> Void
    ) {
        switch pageIndex {
        case 0:
            let date = makeLastPeriodStartDate(
                selectedDayIndex: selectedDay,
                selectedMonthIndex: selectedMonth
            )
            session.updateLastPeriodStarted(date)
            pageIndex += 1

        case 1:
            let durationDays = selectedDurationIndex + 1
            session.updatePeriodDuration(durationDays)
            pageIndex += 1

        case 2:
            finish(context: context, session: session, setHasCompletedOnboarding: setHasCompletedOnboarding)

        default:
            break
        }
    }

    func onNotSureTap(
        context: NSManagedObjectContext,
        session: UserSession,
        setHasCompletedOnboarding: (Bool) -> Void
    ) {
        if isLastPage {
            finish(context: context, session: session, setHasCompletedOnboarding: setHasCompletedOnboarding)
        } else {
            pageIndex += 1
        }
    }

    // MARK: - Private methods
    private func finish(
        context: NSManagedObjectContext,
        session: UserSession,
        setHasCompletedOnboarding: (Bool) -> Void
    ) {
        let lastStart = session.user.initialUserInfo?.lastPeriodStarted
        let durationOpt = session.user.initialUserInfo?.periodDuration

        if let lastStart {
            let duration = max(durationOpt ?? 1, 1)
            do {
                let manager = DayRecordsManager(context: context)
                try manager.saveInitialPeriodDays(lastPeriodStarted: lastStart, durationDays: duration)
            } catch {
                
            }
        }

        setHasCompletedOnboarding(true)
        showMainTab = true
    }

    private func makeLastPeriodStartDate(
        selectedDayIndex: Int,
        selectedMonthIndex: Int,
        today: Date = Date(),
        calendar: Calendar = .current
    ) -> Date? {
        let day = selectedDayIndex + 1
        let month = selectedMonthIndex + 1
        let year = calendar.component(.year, from: today)

        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        comps.hour = 12

        guard let dateThisYear = calendar.date(from: comps) else { return nil }

        if dateThisYear > today {
            comps.year = year - 1
            return calendar.date(from: comps)
        } else {
            return dateThisYear
        }
    }
}
