//
//  CheckInMainScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI
import CoreData

struct CheckInMainScreenView: View {

    @Binding var selectedTab: Int
    @Binding var calendarSelectedDate: Date
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.scenePhase) private var scenePhase

    @State private var showFlow = false
    @State private var isTodayCheckInCompleted = false

    private let calendar = Calendar.current

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()

            VStack {
                if isTodayCheckInCompleted {
                    TodaysCheckInView(selectedTab: $selectedTab, calendarSelectedDate: $calendarSelectedDate)
                } else {
                    StartCheckInView()
                        .padding(.bottom, 40)
                    confirmButton
                }
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
        }
        .onAppear {
            reloadTodayCheckInState()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                reloadTodayCheckInState()
            }
        }
        .fullScreenCover(
            isPresented: $showFlow,
            onDismiss: {
                reloadTodayCheckInState()
            },
            content: {
                CheckInFlowView()
            }
        )
    }

    private var confirmButton: some View {
        Button("Start check-in") {
            guard !isTodayCheckInCompleted else { return }
            showFlow = true
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
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
