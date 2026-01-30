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

    @State private var mood: Mood?
    @State private var pain: PainLevel?
    @State private var energy: EnergyLevel?

    var body: some View {
        VStack {
            titleText

            if let mood, let pain, let energy {
                currentDayInfo(mood: mood, pain: pain, energy: energy)
                    .padding(.top, 20)
                    .padding(.bottom, 40)

                confirmButton
            }
        }
        .background(.white)
        .onAppear { loadToday() }
        .onChange(of: calendar.startOfDay(for: Date())) { _ in
            loadToday()
        }
    }

    private var titleText: some View {
        Text("Today's check-in")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
    }

    private func currentDayInfo(mood: Mood, pain: PainLevel, energy: EnergyLevel) -> some View {
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
            let today = Calendar.current.startOfDay(for: Date()) // ✅
            calendarSelectedDate = today
            selectedTab = 1
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }

    private func loadToday() {
        do {
            let manager = DayRecordsManager(context: context, calendar: calendar)
            let today = calendar.startOfDay(for: Date())

            guard let record = try manager.fetchRecord(for: today) else {
                mood = nil; pain = nil; energy = nil
                return
            }
            
            let m = Mood(rawOrNil: record.mood)
            let p = PainLevel(rawOrNil: record.painLevel)
            let e = EnergyLevel(rawOrNil: record.energy)

            mood = m
            pain = p
            energy = e

        } catch {
            mood = nil; pain = nil; energy = nil
        }
    }
}

//#Preview {
//    TodaysCheckInView()
//        .environment(\.managedObjectContext, CoreDataStack.shared.context)
//}
