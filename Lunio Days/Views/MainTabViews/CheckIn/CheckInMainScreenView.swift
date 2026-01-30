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

    @StateObject private var vm: CheckInMainViewModel

    init(
        selectedTab: Binding<Int>,
        calendarSelectedDate: Binding<Date>,
        context: NSManagedObjectContext? = nil
    ) {
        self._selectedTab = selectedTab
        self._calendarSelectedDate = calendarSelectedDate

        let ctx = context ?? CoreDataStack.shared.context
        _vm = StateObject(wrappedValue: CheckInMainViewModel(context: ctx))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()

            VStack {
                if vm.isTodayCheckInCompleted {
                    TodaysCheckInView(
                        selectedTab: $selectedTab,
                        calendarSelectedDate: $calendarSelectedDate
                    )
                } else {
                    StartCheckInView()
                        .padding(.bottom, 40)

                    confirmButton
                }
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
        }
        .onAppear { vm.onAppear() }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                vm.onBecameActive()
            }
        }
        .fullScreenCover(
            isPresented: $vm.showFlow,
            onDismiss: { vm.onFlowDismiss() },
            content: { CheckInFlowView() }
        )
    }

    private var confirmButton: some View {
        Button("Start check-in") {
            vm.startCheckInTapped()
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
    }
}

// MARK: - Preview

#Preview {
    CheckInMainScreenView(
        selectedTab: .constant(2),
        calendarSelectedDate: .constant(Date()),
        context: CoreDataStack.shared.context
    )
    .environment(\.managedObjectContext, CoreDataStack.shared.context)
    .environmentObject(UserSession())
}
