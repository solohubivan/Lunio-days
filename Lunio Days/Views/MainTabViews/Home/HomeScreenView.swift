//
//  HomeScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI
import CoreData

struct HomeScreenView: View {
    @Binding var selectedTab: Int
    @Binding var calendarSelectedDate: Date
    
//    @State private var calendarSelectedDate: Date = Date()
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var session: UserSession
    @Environment(\.scenePhase) private var scenePhase

    private let calendar = Calendar.current

    @State private var calendarRefreshTrigger: Int = 0
    @State private var isTodayPeriodDay: Bool = false
    @State private var isTodayCheckInCompleted: Bool = false

    var body: some View {
        VStack {
            weekCalendar
            currentDate
            CurrentStateView(
                isPeriodDay: isTodayPeriodDay,
                onStartPeriod: startPeriodToday,
                onEndPeriod: endPeriodToday
            )
            .background(Color.white)
            .cornerRadius(35)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 20)

            checkInButton
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
        }
        .onAppear {
            syncTodayIfNeeded()
//            let manager = DayRecordsManager(context: context)
//                try? manager.deleteAllDayRecords()
            }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                syncTodayIfNeeded()
            }
        }
    }
    
    private var weekCalendar: some View {
//        WeekCalendarView(refreshTrigger: calendarRefreshTrigger)
        WeekCalendarView(
            selectedTab: $selectedTab,
            calendarSelectedDate: $calendarSelectedDate,
            refreshTrigger: calendarRefreshTrigger
        )
            .frame(height: 85)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: -1)
    }
    
    private var currentDate: some View {
        HStack {
            Text(formattedTodayDate)
                .font(.phetsarath(.regular, size: 24))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.leading, 20)
    }

    private var formattedTodayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    
    private var checkInButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedTab = 2
            }
        } label: {
            ZStack {
                LinearGradient(
                    colors: [Color._222, Color.juiceBlue, Color._111],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                HStack(spacing: 0) {
                    Image("pointIcon")
                        .resizable()
                        .scaledToFit()
                        .padding(25)

                    Text(isTodayCheckInCompleted ? "Today’s check-in\ncompleted" : "Complete today’s\ncheck-in")
                        .multilineTextAlignment(.leading)
                        .font(.phetsarath(.bold, size: 16))
                        .foregroundColor(.white)

                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .scaledToFit()
                            .padding(21)

                        
                        Image(isTodayCheckInCompleted ? "galochkaIcon" : "хIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    }
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 4,
                        x: 0,
                        y: 4
                    )
                }
            }
            .frame(height: 85)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        }
    }

    // MARK: - Core logic
    
    private func syncTodayIfNeeded() {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)

            if session.user.periodDay {
                try manager.setPeriodDay(for: Date(), isPeriodDay: true)
            }

            reloadTodayState()
            reloadTodayCheckInState()
            calendarRefreshTrigger += 1
        } catch {
            reloadTodayState()
            reloadTodayCheckInState()
            calendarRefreshTrigger += 1
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

    private func startPeriodToday() {
        do {
            session.startPeriod()
            let manager = DayRecordsManager(context: context, calendar: calendar)
            try manager.setPeriodDay(for: Date(), isPeriodDay: true)
            isTodayPeriodDay = true
            calendarRefreshTrigger += 1
        } catch {
            
        }
    }

    private func endPeriodToday() {
        do {
            session.stopPeriod()
            let manager = DayRecordsManager(context: context, calendar: calendar)
            try manager.setPeriodDay(for: Date(), isPeriodDay: false)
            try manager.clearFuturePeriodDays(from: Date())

            isTodayPeriodDay = false
            calendarRefreshTrigger += 1
        } catch {
            
        }
    }
}

