//
//  TodaysCheckInView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI
import CoreData

struct TodaysCheckInView: View {

    @Binding var selectedTab: Int
    @Binding var calendarSelectedDate: Date

    @Environment(\.managedObjectContext) private var context
    private let calendar = Calendar.current

    @StateObject private var vm: TodaysCheckInViewModel

    init(
        selectedTab: Binding<Int>,
        calendarSelectedDate: Binding<Date>,
        context: NSManagedObjectContext? = nil
    ) {
        self._selectedTab = selectedTab
        self._calendarSelectedDate = calendarSelectedDate

        let ctx = context ?? CoreDataStack.shared.context
        _vm = StateObject(wrappedValue: TodaysCheckInViewModel(context: ctx))
    }

    var body: some View {
        VStack {
            titleText

            if let mood = vm.mood, let pain = vm.pain, let energy = vm.energy {
                currentDayInfo(mood: mood, pain: pain, energy: energy)
                    .padding(.top, 20)
                    .padding(.bottom, 40)

                confirmButton
            }
        }
        .background(Color.white)
        .onAppear { vm.loadToday() }
        .onChange(of: calendar.startOfDay(for: Date())) { _ in
            vm.loadToday()
        }
    }

    private var titleText: some View {
        Text("Today's check-in")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
    }

    private func currentDayInfo(
        mood: Mood,
        pain: PainLevel,
        energy: EnergyLevel
    ) -> some View {
        VStack(spacing: 24) {
            TodaysCheckInCardView(
                title: "Mood",
                statement: mood.title,
                imageName: mood.imageName
            )

            TodaysCheckInCardView(
                title: "Pain",
                statement: pain.title,
                imageName: pain.imageName
            )

            TodaysCheckInCardView(
                title: "Energy",
                statement: energy.title,
                imageName: energy.imageName
            )
        }
    }

    private var confirmButton: some View {
        Button("Open today's summary") {
            calendarSelectedDate = vm.todayStartOfDay()
            selectedTab = 1
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }
}
