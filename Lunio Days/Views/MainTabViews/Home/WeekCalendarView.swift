//
//  WeekCalendarView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI
import CoreData

struct WeekCalendarView: View {

    @Environment(\.managedObjectContext) private var context

    @Binding var selectedTab: Int
    @Binding var calendarSelectedDate: Date

    let refreshTrigger: Int

    @StateObject private var vm: WeekCalendarViewModel

    init(
        selectedTab: Binding<Int>,
        calendarSelectedDate: Binding<Date>,
        refreshTrigger: Int,
        context: NSManagedObjectContext? = nil
    ) {
        self._selectedTab = selectedTab
        self._calendarSelectedDate = calendarSelectedDate
        self.refreshTrigger = refreshTrigger

        let ctx = context ?? CoreDataStack.shared.context
        _vm = StateObject(wrappedValue: WeekCalendarViewModel(context: ctx))
    }

    var body: some View {
        HStack(spacing: 4) {
            Spacer()

            ForEach(0..<7, id: \.self) { index in
                let offset = index - 3
                dayCell(for: offset)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(8)
        .onAppear { vm.onAppear() }
        .onChange(of: refreshTrigger) { _ in vm.onRefreshTriggerChanged() }
        .onChange(of: Calendar.current.startOfDay(for: Date())) { _ in vm.onDayChanged() }
    }

    // MARK: - Cell

    private func dayCell(for offset: Int) -> some View {
        let date = vm.dateForOffset(offset)
        let dayNumber = vm.dayNumber(from: date)

        let isToday = vm.isToday(date)
        let isPeriod = vm.isPeriodDay(date)
        let showDot = vm.hasCheckIn(date)

        let backgroundColor: Color = isPeriod ? (isToday ? ._11 : ._111) : .white
        let numberColor: Color = isPeriod ? (isToday ? .black : .white) : (isToday ? ._111 : .black)
        let weekdayColor: Color = isPeriod ? (isToday ? .black : ._111) : (isToday ? ._111 : .black)
        let borderLine: Color = (isToday && !isPeriod) ? ._111 : .clear
        let checkInPoint: Color = isPeriod ? (isToday ? .clear : .white) : (isToday ? .clear : ._111)

        return VStack(spacing: 0) {
            Text(vm.weekdayTitle(from: date))
                .font(.phetsarath(.regular, size: 12))
                .foregroundColor(weekdayColor)

            ZStack {
                Text("\(dayNumber)")
                    .font(.phetsarath(.regular, size: 16))
                    .foregroundColor(numberColor)
                    .frame(width: 44, height: 44)
                    .background(backgroundColor)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(borderLine, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)

                if showDot {
                    VStack {
                        Circle()
                            .fill(checkInPoint)
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            calendarSelectedDate = date
            selectedTab = 1
        }
    }
}

// MARK: - Preview

#Preview {
    WeekCalendarView(
        selectedTab: .constant(0),
        calendarSelectedDate: .constant(Date()),
        refreshTrigger: 0,
        context: CoreDataStack.shared.context
    )
    .environment(\.managedObjectContext, CoreDataStack.shared.context)
}
