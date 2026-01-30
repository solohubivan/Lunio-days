//
//  OnboardingQuestionsScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct OnboardingQuestionsScreenView: View {
    
    @Environment(\.managedObjectContext) private var context
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @EnvironmentObject private var session: UserSession
    @State private var showMainTab = false
    
    @State private var pageIndex = 0
    @State private var selectedDay: Int = 0
    @State private var selectedMonth: Int = 0
    @State private var selectedDurationIndex: Int = 3
    
    var body: some View {
        ZStack {
            if showMainTab {
                MainTabView()
                    .transition(.opacity)
            } else {
                onboardingContent
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showMainTab)
    }

    private var onboardingContent: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Spacer()
                currentPage
                    .padding(.horizontal, 20)
                    .padding(.bottom, 35)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomSlot
                .ignoresSafeArea(edges: .horizontal)
                .padding(.bottom, 10)
        }
        .animation(.bouncy(duration: 0.6), value: pageIndex)
    }
    
    private var currentPage: some View {
        Group {
            switch pageIndex {
            case 0:
                LastPeriodStartPickerView(
                    selectedDay: $selectedDay,
                    selectedMonth: $selectedMonth
                )
            case 1:
                PeriodsDurationPickerView(selectedDurationIndex: $selectedDurationIndex)
            case 2:
                AvarageCycleDaysPickerView()
            default:
                EmptyView()
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
        .id(pageIndex)
    }
    
    private var bottomSlot: some View {
        VStack(spacing: 16) {
            notSureButton
            nextButton
                .padding(.bottom, 20)
            PageDotsIndicatorView(total: 3, selectedIndex: pageIndex)
        }
        .padding(.horizontal, 20)
    }
    
    private var isLastPage: Bool {
        pageIndex == 2
    }

    private var nextButtonTitle: String {
        isLastPage ? "Finish" : "Next"
    }

    private var nextButton: some View {
        Button(nextButtonTitle) {
            onNextTap()
        }
        .font(.phetsarath(.bold, size: 24))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }
    
    private func onNextTap() {
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
            let lastStart = session.user.initialUserInfo?.lastPeriodStarted
            let durationOpt = session.user.initialUserInfo?.periodDuration

            if let lastStart {
                let duration = max(durationOpt ?? 1, 1)
                do {
                    let manager = DayRecordsManager(context: context)
                    try manager.saveInitialPeriodDays(lastPeriodStarted: lastStart, durationDays: duration)
                } catch {
                    
                }
            } else {
                
            }

            withAnimation(.easeInOut(duration: 0.35)) {
                hasCompletedOnboarding = true
                showMainTab = true
            }

        default:
            break
        }
    }
    
    private var notSureButton: some View {
        Button("Not sure") {
            if isLastPage {
                withAnimation {
                    hasCompletedOnboarding = true
                    showMainTab = true
                }
            } else {
                pageIndex += 1
            }
        }
        .font(.phetsarath(.regular, size: 20))
        .buttonStyle(OutlineButtonStyle())
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

//#Preview {
//    OnboardingQuestionsScreenView()
//}
