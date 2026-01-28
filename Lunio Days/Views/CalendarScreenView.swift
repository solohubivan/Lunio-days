//
//  CalendarScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 28.01.2026.
//

import SwiftUI
import FSCalendar

struct CalendarScreenView: View {

    @State private var selectedDate: Date = .init()
    @State private var currentPage: Date = .init()

    @State private var isBottomExpanded = false

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
    }

    // MARK: - Collapsed (під календарем)

    private var collapsedBottomCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("December 18")
                        .font(.phetsarath(.bold, size: 20))
                        .foregroundColor(.brownText)
                    
                    Text("Cycle day")
                        .font(.phetsarath(.bold, size: 16))
                        .foregroundColor(._222)
                }
                
                Spacer()
                
                CircularExpandButton {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isBottomExpanded = true
                    }
                }
                
            }
            .padding(.horizontal, 22)
            .padding(.top, 25)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(TopCornersRoundedShape(radius: 29))
                .shadow(color: .black.opacity(0.25), radius: 1, x: -1, y: -1)
        )
    }

    // MARK: - Expanded (на весь екран)

    private var expandedBottomView: some View {
        VStack(spacing: 0) {
            // header
            HStack {
                Text("Details")
                    .foregroundColor(.brownText)
                    .font(.phetsarath(.bold, size: 18))

                Spacer()

                Button("Close") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isBottomExpanded = false
                    }
                }
                .font(.phetsarath(.regular, size: 16))
                .foregroundColor(.brownText)
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 10)

            // content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Full information for selected day:")
                        .font(.phetsarath(.bold, size: 16))
                        .foregroundColor(.brownText)

                    ForEach(0..<20, id: \.self) { i in
                        Text("• item \(i + 1)")
                            .font(.phetsarath(.regular, size: 14))
                            .foregroundColor(.brownText)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color.white.ignoresSafeArea(edges: .bottom)
                .clipShape(TopCornersRoundedShape(radius: 29))
                .shadow(color: .black.opacity(0.25), radius: 4, x: -1, y: -1)
        )
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Calendar
    private var customCalendar: some View {
        VStack(spacing: 10) {
            calendarTopLine

            FSCalendarRepresentable(selectedDate: $selectedDate, currentPage: $currentPage)
                .frame(height: 300)
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

    private func changeMonth(by value: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentPage) else { return }
        currentPage = newDate
    }
}

#Preview {
    CalendarScreenView()
//    MainTabView()
        .environmentObject(UserSession())
}




// MARK: - FSCalendar bridge


struct FSCalendarRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var currentPage: Date

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
            calendar.delegate = context.coordinator
            calendar.dataSource = context.coordinator

            calendar.firstWeekday = 2

            calendar.scrollDirection = .horizontal
            calendar.scope = .month
            calendar.headerHeight = 0
            calendar.placeholderType = .fillHeadTail

        // MARK: - Weekdays style
        calendar.appearance.weekdayFont = UIFont(
            name: "phetsarath-regular",
            size: 14
        ) ?? .systemFont(ofSize: 14, weight: .bold)

        calendar.appearance.weekdayTextColor = UIColor(
            named: "brownTextColor"
        ) ?? .brown
        
        calendar.appearance.titleFont = UIFont(
            name: "phetsarath-regular",
            size: 16
        ) ?? .systemFont(ofSize: 16, weight: .regular)
        
        calendar.appearance.titleDefaultColor = UIColor(
            named: "brownTextColor"
        ) ?? .brown
        
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear

        calendar.appearance.borderSelectionColor = UIColor(Color._222)

        calendar.appearance.borderRadius = 1.0
        
        calendar.appearance.titleTodayColor = UIColor(Color._111)
        calendar.appearance.titleSelectionColor = UIColor(Color.brownText)
        
        calendar.select(selectedDate)
        calendar.setCurrentPage(currentPage, animated: false)
        
        lowercaseWeekdayLabels(in: calendar)
        addWeekdaySeparator(to: calendar)

        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // синхронізуємо selection
        if uiView.selectedDate != selectedDate {
            uiView.select(selectedDate)
        }

        // синхронізуємо page (наприклад, якщо ти кнопками листатимеш)
        if !Calendar.current.isDate(uiView.currentPage, equalTo: currentPage, toGranularity: .month) {
            uiView.setCurrentPage(currentPage, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate, currentPage: $currentPage)
    }

    private func addWeekdaySeparator(to calendar: FSCalendar) {
        let separator = UIView()
        separator.backgroundColor = UIColor(Color._111)
        separator.translatesAutoresizingMaskIntoConstraints = false

        calendar.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: calendar.leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -10),
            separator.topAnchor.constraint(equalTo: calendar.calendarWeekdayView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func lowercaseWeekdayLabels(in calendar: FSCalendar) {
        for label in calendar.calendarWeekdayView.weekdayLabels {
            label.text = label.text?.lowercased()
        }
    }
    
    
    
    
    final class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        @Binding var selectedDate: Date
        @Binding var currentPage: Date

        init(selectedDate: Binding<Date>, currentPage: Binding<Date>) {
            _selectedDate = selectedDate
            _currentPage = currentPage
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            selectedDate = date
            
            if monthPosition != .current {
                currentPage = calendar.currentPage
            }
        }

        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            currentPage = calendar.currentPage
        }
    }
}
