//
//  CalendarScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 28.01.2026.
//

import SwiftUI
import CoreData

struct CalendarScreenView: View {

    @Binding var selectedTab: Int
    @Binding var selectedDate: Date

    @Environment(\.managedObjectContext) private var context
    @AppStorage("soundEnabled") private var soundEnabled: Bool = false
    @StateObject private var vm: CalendarScreenViewModel

    init(
        selectedTab: Binding<Int>,
        selectedDate: Binding<Date>
    ) {
        self._selectedTab = selectedTab
        self._selectedDate = selectedDate
        
        _vm = StateObject(wrappedValue: CalendarScreenViewModel(context: CoreDataStack.shared.context))
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            if vm.isBottomExpanded {
                expandedBottomView
                    .transition(.move(edge: .bottom))
            } else {
                VStack(spacing: 20) {
                    customCalendar
                    collapsedBottomCard
                        .transition(.opacity)
                }
                .padding(.top, 20)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: vm.isBottomExpanded)
        .onAppear {
            if vmContextMismatch {
            }
            vm.onAppear(selectedDate: selectedDate)
        }
        .onChange(of: selectedDate) { newValue in
            vm.onSelectedDateChanged(newValue)
        }
    }

    private var vmContextMismatch: Bool { false }

    // MARK: - UI components
    private var customCalendar: some View {
        VStack(spacing: 10) {
            calendarTopLine

            FSCalendarRepresentable(
                selectedDate: $selectedDate,
                currentPage: $vm.currentPage,
                markedDays: vm.periodDays,
                checkInDays: vm.checkInDays,
                soundEnabled: soundEnabled
            )
            .frame(height: 290)
        }
        .padding(.horizontal, 28)
    }

    private var calendarTopLine: some View {
        HStack {
            Text(vm.currentPage.formatted(.dateTime.month(.wide).year()))
                .foregroundColor(.brownText)
                .font(.phetsarath(.bold, size: 25))

            Spacer()

            calendarButtons
        }
        .padding(.horizontal, 10)
    }

    private var calendarButtons: some View {
        HStack(spacing: 20) {
            Button { vm.changeMonth(by: -1) } label: {
                Image("arrowButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                    .rotationEffect(.degrees(180))
            }

            Button { vm.changeMonth(by: 1) } label: {
                Image("arrowButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
            }
        }
    }

    private var bottomCardHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedDate.formatted(.dateTime.month(.wide).day()))
                    .font(.phetsarath(.bold, size: 20))
                    .foregroundColor(.brownText)

                if vm.shouldShowCycleOrPeriodLabel(selectedDate: selectedDate) {
                    Text(vm.isPeriodSelectedDay(selectedDate: selectedDate) ? "Period day" : "Cycle day")
                        .font(.phetsarath(.bold, size: 16))
                        .foregroundColor(vm.isPeriodSelectedDay(selectedDate: selectedDate) ? Color._111 : Color._222)
                }
            }

            Spacer()

            CircularExpandButton {
                withAnimation(.easeInOut(duration: 0.25)) {
                    vm.toggleBottomExpanded()
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
    }

    // MARK: - Collapsed bottom card
    private var collapsedBottomCard: some View {
        VStack {
            bottomCardHeader
            Spacer()

            if vm.isCheckInSelectedDay(selectedDate: selectedDate) {
                completedCheckIn
            } else if vm.isTodaySelected(selectedDate: selectedDate) {
                todayCheckInMissing
            } else {
                otherDayCheckInMissing
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(TopCornersRoundedShape(radius: 29))
                .shadow(color: .black.opacity(0.25), radius: 1, x: -1, y: -1)
        )
    }

    private var completedCheckIn: some View {
        VStack(spacing: 14) {
            checkInRow(
                title: "Mood",
                value: Mood(rawOrNil: vm.selectedDayRecord?.mood ?? -1)?.title ?? "—",
                imageName: Mood(rawOrNil: vm.selectedDayRecord?.mood ?? -1)?.imageName ?? "smile"
            )

            checkInRow(
                title: "Pain",
                value: PainLevel(rawOrNil: vm.selectedDayRecord?.painLevel ?? -1)?.title ?? "—",
                imageName: PainLevel(rawOrNil: vm.selectedDayRecord?.painLevel ?? -1)?.imageName ?? "smile"
            )

            checkInRow(
                title: "Energy",
                value: EnergyLevel(rawOrNil: vm.selectedDayRecord?.energy ?? -1)?.title ?? "—",
                imageName: EnergyLevel(rawOrNil: vm.selectedDayRecord?.energy ?? -1)?.imageName ?? "smile"
            )
        }
        .padding(.horizontal, 20)
    }

    private var otherDayCheckInMissing: some View {
        VStack {
            Text(makeHighlightedText(
                fullText: "Check-ins can only be\ncompleted on the selected day",
                baseColor: .brownText,
                highlights: ["selected day": ._111]
            ))
            .font(.petrona(.bold, size: 24))
            .multilineTextAlignment(.center)

            Button("Start check-in") { }
                .font(.phetsarath(.bold, size: 20))
                .buttonStyle(FullWidthButtonStyle(
                    backgroundColor: Color.gray.opacity(0.2),
                    solidTextColor: .white
                ))
                .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
                .padding(.top, 25)
        }
        .padding(.horizontal, 20)
    }

    private var todayCheckInMissing: some View {
        VStack {
            Text(makeHighlightedText(
                fullText: "Today’s check-in is\nmissing",
                baseColor: .brownText,
                highlights: ["check-in": ._111]
            ))
            .font(.petrona(.bold, size: 24))
            .multilineTextAlignment(.center)

            Text("Take a moment to complete it")
                .font(.phetsarath(.regular, size: 16))
                .foregroundColor(.brownText)
                .padding(.top, 10)

            Button("Start check-in") { selectedTab = 2 }
                .font(.phetsarath(.bold, size: 20))
                .buttonStyle(FullWidthButtonStyle())
                .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
                .padding(.top, 20)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Row UI helper
    private func checkInRow(title: String, value: String, imageName: String) -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color._222, lineWidth: 1)
                .frame(height: 50)
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

            HStack {
                Text(title)
                    .font(.phetsarath(.regular, size: 14))
                    .foregroundColor(._222)
                    .padding(.horizontal, 4)
                    .background(Color.white)
                Spacer()
            }
            .offset(y: -10)
            .padding(.leading, 25)

            HStack {
                Text(value)
                    .font(.phetsarath(.regular, size: 16))
                    .foregroundColor(.brownText)
                Spacer()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
            }
            .frame(height: 50)
            .padding(.horizontal, 15)
        }
    }

    // MARK: - Expanded bottom card
    private var expandedBottomView: some View {
        VStack {
            bottomCardHeader
                .padding(.bottom, 30)

            if vm.isCheckInSelectedDay(selectedDate: selectedDate) {
                expandedCompletedCheckIn
            } else if vm.isTodaySelected(selectedDate: selectedDate) {
                expandedTodayCheckInMissing
            } else {
                expandedOtherDayCheckInMissing
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.white.ignoresSafeArea(edges: .bottom)
                .clipShape(TopCornersRoundedShape(radius: 29))
                .shadow(color: .black.opacity(0.25), radius: 1, x: -1, y: -1)
        )
    }

    private var expandedOtherDayCheckInMissing: some View {
        VStack {
            Spacer()

            Image("image60")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 70)

            Text(
                makeHighlightedText(
                    fullText: "Today’s check-in is\nmissing",
                    baseColor: .brownText,
                    highlights: ["check-in": ._111]
                )
            )
            .font(.petrona(.bold, size: 36))
            .multilineTextAlignment(.center)
            .padding(.top, 25)

            Text("Check-ins can only be\ncompleted on the selected day")
                .multilineTextAlignment(.center)
                .font(.phetsarath(.regular, size: 20))
                .foregroundColor(.brownText)
                .padding(.top, 10)

            Spacer()

            Button("Start check-in") { }
                .font(.phetsarath(.bold, size: 20))
                .buttonStyle(
                    FullWidthButtonStyle(
                        backgroundColor: Color.gray.opacity(0.2),
                        solidTextColor: .white
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
                .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }
    
    private var expandedTodayCheckInMissing: some View {
        VStack {
            Spacer()

            Image("image60")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 70)

            Text(
                makeHighlightedText(
                    fullText: "Today’s check-in is\nmissing",
                    baseColor: .brownText,
                    highlights: ["check-in": ._111]
                )
            )
            .font(.petrona(.bold, size: 36))
            .multilineTextAlignment(.center)
            .padding(.top, 25)

            Text("Take a moment to complete it")
                .font(.phetsarath(.regular, size: 20))
                .foregroundColor(.brownText)
                .padding(.top, 10)

            Spacer()

            Button("Start check-in") {
                selectedTab = 2
            }
            .font(.phetsarath(.bold, size: 20))
            .buttonStyle(FullWidthButtonStyle())
            .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }
    
    private var expandedCompletedCheckIn: some View {
        VStack {
            VStack(spacing: 25) {
                expandedCheckInRow(
                    title: "Mood",
                    value: Mood(rawOrNil: vm.selectedDayRecord?.mood ?? -1)?.title ?? "—",
                    imageName: Mood(rawOrNil: vm.selectedDayRecord?.mood ?? -1)?.imageName ?? "smile"
                )

                expandedCheckInRow(
                    title: "Pain",
                    value: PainLevel(rawOrNil: vm.selectedDayRecord?.painLevel ?? -1)?.title ?? "—",
                    imageName: PainLevel(rawOrNil: vm.selectedDayRecord?.painLevel ?? -1)?.imageName ?? "smile"
                )

                expandedCheckInRow(
                    title: "Energy",
                    value: EnergyLevel(rawOrNil: vm.selectedDayRecord?.energy ?? -1)?.title ?? "—",
                    imageName: EnergyLevel(rawOrNil: vm.selectedDayRecord?.energy ?? -1)?.imageName ?? "smile"
                )
            }

            Spacer()

            Button("Back to Today") {
                selectedTab = 0
            }
            .font(.phetsarath(.bold, size: 20))
            .buttonStyle(FullWidthButtonStyle())
            .shadow(color: .black.opacity(0.3), radius: 2, y: 2)

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    private func expandedCheckInRow(
        title: String,
        value: String,
        imageName: String
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.white)
                .frame(height: 116)
                .shadow(color: .black.opacity(0.25), radius: 2, y: 2)

            RoundedRectangle(cornerRadius: 9)
                .stroke(Color._222, lineWidth: 1)
                .frame(height: 116)

            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.phetsarath(.bold, size: 24))
                        .foregroundColor(._111)

                    Text(value)
                        .font(.phetsarath(.regular, size: 16))
                        .foregroundColor(.brownText)
                }

                Spacer()

                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54)
            }
            .padding(.horizontal, 15)
        }
    }
}
