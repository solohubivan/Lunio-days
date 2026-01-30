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

    @Environment(\.managedObjectContext) private var context

//    @State private var selectedDate: Date = .init()
    @Binding var selectedDate: Date
    
    @State private var currentPage: Date = .init()

    @State private var isBottomExpanded = false
    
    @State private var periodDays: Set<Date> = []
    @State private var checkInDays: Set<Date> = []
    
    @State private var selectedDayRecord: DayRecord?

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            if isBottomExpanded {
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
        .animation(.easeInOut(duration: 0.25), value: isBottomExpanded)
//        .onChange(of: selectedDate) { _ in
//            loadSelectedDayRecord()
//        }
//        .onAppear {
//            loadAllPeriodDays()
//            loadAllCheckInDays()
//            loadSelectedDayRecord()
//        }
        .onAppear {
                    currentPage = selectedDate
                    loadAllPeriodDays()
                    loadAllCheckInDays()
                    loadSelectedDayRecord()
                }
                .onChange(of: selectedDate) { _ in
                    currentPage = selectedDate
                    loadSelectedDayRecord()
                }
    }
    
    // MARK: - UI components
    private var customCalendar: some View {
        VStack(spacing: 10) {
            calendarTopLine

            FSCalendarRepresentable(
                selectedDate: $selectedDate,
                currentPage: $currentPage,
                markedDays: periodDays,
                checkInDays: checkInDays
            )
            .frame(height: 290)
        }
        .padding(.horizontal, 28)
    }
    
    private var calendarTopLine: some View {
        HStack {
            Text(currentPage.formatted(.dateTime.month(.wide).year()))
                .foregroundColor(.brownText)
                .font(.phetsarath(.bold, size: 25))

            Spacer()

            calendarButtons
        }
        .padding(.horizontal, 10)
    }
    
    private var calendarButtons: some View {
        HStack(spacing: 20) {
            Button { changeMonth(by: -1) } label: {
                Image("arrowButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                    .rotationEffect(.degrees(180))
            }

            Button { changeMonth(by: 1) } label: {
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

                if shouldShowCycleOrPeriodLabel() {
                    Text(isPeriodSelectedDay() ? "Period day" : "Cycle day")
                        .font(.phetsarath(.bold, size: 16))
                        .foregroundColor(isPeriodSelectedDay() ? Color._111 : Color._222)
                }
            }
            
            Spacer()
            
            CircularExpandButton {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isBottomExpanded.toggle()
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
            
            if isCheckInSelectedDay() {
                completedCheckIn
            } else if isTodaySelected() {
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
                value: Mood(rawOrNil: selectedDayRecord?.mood ?? -1)?.title ?? "—",
                imageName: Mood(rawOrNil: selectedDayRecord?.mood ?? -1)?.imageName ?? "smile"
            )

            checkInRow(
                title: "Pain",
                value: PainLevel(rawOrNil: selectedDayRecord?.painLevel ?? -1)?.title ?? "—",
                imageName: PainLevel(rawOrNil: selectedDayRecord?.painLevel ?? -1)?.imageName ?? "smile"
            )

            checkInRow(
                title: "Energy",
                value: EnergyLevel(rawOrNil: selectedDayRecord?.energy ?? -1)?.title ?? "—",
                imageName: EnergyLevel(rawOrNil: selectedDayRecord?.energy ?? -1)?.imageName ?? "smile"
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var otherDayCheckInMissing: some View {
        VStack {
            Text(makeHighlightedText(fullText: "Check-ins can only be\ncompleted on the selected day", baseColor: .brownText, highlights: ["selected day": ._111]))
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
            Text(makeHighlightedText(fullText: "Today’s check-in is\nmissing", baseColor: .brownText, highlights: ["check-in": ._111]))
                .font(.petrona(.bold, size: 24))
                .multilineTextAlignment(.center)
            
            Text("Take a moment to complete it")
                .font(.phetsarath(.regular, size: 16))
                .foregroundColor(.brownText)
                .padding(.top, 10)
            
            Button("Start check-in") {
                selectedTab = 2
            }
            .font(.phetsarath(.bold, size: 20))
            .buttonStyle(FullWidthButtonStyle())
            .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - private helper
    private func checkInRow(
        title: String,
        value: String,
        imageName: String
    ) -> some View {

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
            
            if isCheckInSelectedDay() {
                expandedCompletedCheckIn
            } else if isTodaySelected() {
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
            
            Text(makeHighlightedText(fullText: "Today’s check-in is\nmissing", baseColor: .brownText, highlights: ["check-in": ._111]))
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
            .buttonStyle(FullWidthButtonStyle(
                backgroundColor: Color.gray.opacity(0.2),
                solidTextColor: .white
            ))
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
            
            Text(makeHighlightedText(fullText: "Today’s check-in is\nmissing", baseColor: .brownText, highlights: ["check-in": ._111]))
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
                    value: Mood(rawOrNil: selectedDayRecord?.mood ?? -1)?.title ?? "—",
                    imageName: Mood(rawOrNil: selectedDayRecord?.mood ?? -1)?.imageName ?? "smile"
                )

                expandedCheckInRow(
                    title: "Pain",
                    value: PainLevel(rawOrNil: selectedDayRecord?.painLevel ?? -1)?.title ?? "—",
                    imageName: PainLevel(rawOrNil: selectedDayRecord?.painLevel ?? -1)?.imageName ?? "smile"
                )

                expandedCheckInRow(
                    title: "Energy",
                    value: EnergyLevel(rawOrNil: selectedDayRecord?.energy ?? -1)?.title ?? "—",
                    imageName: EnergyLevel(rawOrNil: selectedDayRecord?.energy ?? -1)?.imageName ?? "smile"
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
    
    // MARK: - private helper
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
    
    // MARK: - Private methods
    
    private func loadSelectedDayRecord() {
        do {
            let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()

            let cal = Calendar.current
            let start = cal.startOfDay(for: selectedDate)
            let end = cal.date(byAdding: .day, value: 1, to: start)!

            request.predicate = NSPredicate(format: "date >= %@ AND date < %@", start as NSDate, end as NSDate)
            request.fetchLimit = 1
            request.returnsObjectsAsFaults = false

            selectedDayRecord = try context.fetch(request).first
        } catch {
            selectedDayRecord = nil
        }
    }
    
    private func normalize(_ d: Date) -> Date {
            let cal = Calendar.current
            return cal.date(bySettingHour: 12, minute: 0, second: 0, of: d) ?? d
        }
    
    private func loadAllCheckInDays() {
            do {
                let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
                request.predicate = NSPredicate(
                    format: "date != nil AND mood != -1 AND painLevel != -1 AND energy != -1"
                )
                request.returnsObjectsAsFaults = false

                let results = try context.fetch(request)
                checkInDays = Set(results.compactMap { $0.date }.map(normalize))
            } catch {
                checkInDays = []
            }
        }


    private func loadAllPeriodDays() {
        do {
            let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
            request.predicate = NSPredicate(format: "isPeriodDay == YES AND date != nil")
            request.returnsObjectsAsFaults = false

            let results = try context.fetch(request)

            let cal = Calendar.current
            func normalize(_ d: Date) -> Date {
                cal.date(bySettingHour: 12, minute: 0, second: 0, of: d) ?? d
            }

            periodDays = Set(results.compactMap { $0.date }.map(normalize))

        } catch {
            periodDays = []
        }
    }
    
    
    
    

    private func changeMonth(by value: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentPage) else { return }
        currentPage = newDate
    }
    
    private func isPeriodSelectedDay() -> Bool {
        let cal = Calendar.current
        let normalized = cal.date(bySettingHour: 12, minute: 0, second: 0, of: selectedDate) ?? selectedDate
        return periodDays.contains(normalized)
    }
    
    private func isTodaySelected() -> Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: Date())
    }

    private func isCheckInSelectedDay() -> Bool {
        let normalized = normalize(selectedDate)
        return checkInDays.contains(normalized)
    }
    
    private func isFutureSelectedDay() -> Bool {
        let cal = Calendar.current
        let selectedStart = cal.startOfDay(for: selectedDate)
        let todayStart = cal.startOfDay(for: Date())
        return selectedStart > todayStart
    }

    private func shouldShowCycleOrPeriodLabel() -> Bool {
        if isPeriodSelectedDay() { return true }
        return !isFutureSelectedDay()
    }
    
}

//#Preview {
//    CalendarScreenView()
////    MainTabView()
//        .environmentObject(UserSession())
//}
