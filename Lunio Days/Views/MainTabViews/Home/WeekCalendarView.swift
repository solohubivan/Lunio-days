//
//  WeekCalendarView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct WeekCalendarView: View {
    
    @EnvironmentObject private var session: UserSession

    private let calendar = Calendar.current

    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            
            ForEach(0..<7, id: \.self) { index in
                let offset = index - 3
                dayCell(for: offset, isToday: offset == 0)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(8)
    }



    private func weekdayTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).lowercased()
    }
    
    private func isPeriodDay(date: Date) -> Bool {
        guard session.user.periodDay else { return false }

        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)

        // приклад: сьогодні + 2 дні назад
        let diff = calendar.dateComponents([.day], from: target, to: today).day ?? 0
        return diff >= 0 && diff <= 2
    }
    

    private func dayCell(for offset: Int, isToday: Bool) -> some View {
        let date = calendar.date(byAdding: .day, value: offset, to: Date()) ?? Date()
        let dayNumber = calendar.component(.day, from: date)

        let isPeriod = isPeriodDay(date: date)
        let isTodayPeriod = isToday && session.user.periodDay

        // фон
        let backgroundColor: Color = {
            if isTodayPeriod { return ._11 }
            if isPeriod { return ._111 }
            return .white
        }()

        // колір weekday (EEE)
        let weekdayColor: Color = {
            if isPeriod { return .black }
            if isToday { return .pink }
            return .black
        }()

        // колір числа
        let numberColor: Color = {
            if isTodayPeriod { return .black }
            if isPeriod { return .white }
            if isToday { return .pink }
            return .black
        }()
        
        let boardLine: Color = {
            if isToday && !isPeriod { return .pink }
            return .clear
        }()

        return VStack(spacing: 0) {
            Text(weekdayTitle(from: date))
                .font(.phetsarath(.regular, size: 12))
                .foregroundColor(weekdayColor)

            Text("\(dayNumber)")
                .font(.phetsarath(.regular, size: 16))
                .foregroundColor(numberColor)
                .frame(width: 44, height: 44)
                .background(backgroundColor)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(boardLine, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
            
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
//    WeekCalendarView()
    MainTabView()
        .environmentObject(UserSession())
}
