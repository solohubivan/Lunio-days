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

    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var session: UserSession
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var vm: HomeScreenViewModel

    init(
        selectedTab: Binding<Int>,
        calendarSelectedDate: Binding<Date>,
        context: NSManagedObjectContext? = nil
    ) {
        self._selectedTab = selectedTab
        self._calendarSelectedDate = calendarSelectedDate

        let ctx = context ?? CoreDataStack.shared.context
        _vm = StateObject(wrappedValue: HomeScreenViewModel(context: ctx))
    }

    var body: some View {
        VStack {
            weekCalendar

            currentDate

            CurrentStateView(
                isPeriodDay: vm.isTodayPeriodDay,
                onStartPeriod: { vm.startPeriodToday(session: session) },
                onEndPeriod: { vm.endPeriodToday(session: session) }
            )
            .background(Color.white)
            .cornerRadius(35)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
            .padding(.horizontal, 20)

            checkInButton
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
        }
        .onAppear { vm.onAppear(session: session) }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                vm.onBecameActive(session: session)
            }
        }
    }

    private var weekCalendar: some View {
        WeekCalendarView(
            selectedTab: $selectedTab,
            calendarSelectedDate: $calendarSelectedDate,
            refreshTrigger: vm.calendarRefreshTrigger
        )
        .frame(height: 85)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: -1)
    }

    private var currentDate: some View {
        HStack {
            Text(vm.formattedTodayDate)
                .font(.phetsarath(.regular, size: 24))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.leading, 20)
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

                    Text(vm.isTodayCheckInCompleted
                         ? "Today’s check-in\ncompleted"
                         : "Complete today’s\ncheck-in"
                    )
                    .multilineTextAlignment(.leading)
                    .font(.phetsarath(.bold, size: 16))
                    .foregroundColor(.white)

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .scaledToFit()
                            .padding(21)

                        Image(vm.isTodayCheckInCompleted ? "galochkaIcon" : "хIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    }
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                }
            }
            .frame(height: 85)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        }
    }
}

#Preview {
    HomeScreenView(
        selectedTab: .constant(0),
        calendarSelectedDate: .constant(Date()),
        context: CoreDataStack.shared.context
    )
    .environment(\.managedObjectContext, CoreDataStack.shared.context)
    .environmentObject(UserSession())
}
