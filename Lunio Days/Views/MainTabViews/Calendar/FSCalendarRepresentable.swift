//
//  FSCalendarRepresentable.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import FSCalendar

struct FSCalendarRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date
    @Binding var currentPage: Date
    
    var markedDays: Set<Date>
    var checkInDays: Set<Date>

    private let cal = Calendar.current

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator

        calendar.firstWeekday = 2
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.headerHeight = 0
        calendar.placeholderType = .fillHeadTail

        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.borderSelectionColor = UIColor(Color._222)
        calendar.appearance.borderRadius = 1.0
        
        calendar.appearance.titleTodayColor = UIColor(Color.brownText)
        calendar.appearance.weekdayTextColor = UIColor(Color.brownText)
        
        calendar.appearance.weekdayFont = UIFont(
            name: "phetsarath-regular",
            size: 16
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
        
        
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -40)

        calendar.select(selectedDate)
        calendar.setCurrentPage(currentPage, animated: false)
        
        lowercaseWeekdayLabels(in: calendar)
        addWeekdaySeparator(to: calendar)
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        context.coordinator.markedDays = markedDays
        context.coordinator.checkInDays = checkInDays

        let newHash = markedDays.hashValue ^ checkInDays.hashValue
        if context.coordinator.combinedHash != newHash {
            context.coordinator.combinedHash = newHash

            if uiView.bounds.size == .zero {
                DispatchQueue.main.async { uiView.reloadData() }
            } else {
                UIView.performWithoutAnimation { uiView.reloadData() }
            }
        }

        if uiView.selectedDate != selectedDate {
            uiView.select(selectedDate)
        }

        if !Calendar.current.isDate(uiView.currentPage, equalTo: currentPage, toGranularity: .month) {
            uiView.setCurrentPage(currentPage, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            selectedDate: $selectedDate,
            currentPage: $currentPage,
            markedDays: markedDays,
            checkInDays: checkInDays
        )
    }
    
    // MARK: - Private methods
    private func addWeekdaySeparator(to calendar: FSCalendar) {
        let tag = 987_654

        if calendar.viewWithTag(tag) != nil { return }

        let separator = UIView()
        separator.tag = tag
        separator.backgroundColor = UIColor(Color.tabbarChoosedItem)
        separator.translatesAutoresizingMaskIntoConstraints = false

        calendar.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: calendar.leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -10),
            separator.topAnchor.constraint(equalTo: calendar.calendarWeekdayView.bottomAnchor, constant: 0),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func lowercaseWeekdayLabels(in calendar: FSCalendar) {
        calendar.calendarWeekdayView.weekdayLabels.forEach {
            $0.text = $0.text?.lowercased()
        }
    }

    // MARK: - Coordinator
    final class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

        @Binding var selectedDate: Date
        @Binding var currentPage: Date

        var markedDays: Set<Date>
        var checkInDays: Set<Date>

        var combinedHash: Int = 0

        private let cal = Calendar.current

        init(selectedDate: Binding<Date>,
             currentPage: Binding<Date>,
             markedDays: Set<Date>,
             checkInDays: Set<Date>) {
            
            _selectedDate = selectedDate
            _currentPage = currentPage
            self.markedDays = markedDays
            self.checkInDays = checkInDays
            self.combinedHash = markedDays.hashValue ^ checkInDays.hashValue
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
        
        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      titleSelectionColorFor date: Date) -> UIColor? {

            return isMarked(date) ? .white : .brownText
        }
        
        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      fillSelectionColorFor date: Date) -> UIColor? {

            return isMarked(date) ? UIColor.tabbarChoosedItem : .clear
        }
        
        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      fillDefaultColorFor date: Date) -> UIColor? {

            return isMarked(date) ? UIColor.tabbarChoosedItem : nil
        }

        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      titleDefaultColorFor date: Date) -> UIColor? {

            return isMarked(date) ? .white : nil
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return hasCheckIn(date) ? 1 : 0
        }

        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      eventDefaultColorsFor date: Date) -> [UIColor]? {

            guard hasCheckIn(date) else { return nil }
            return [UIColor._111]
        }

        func calendar(_ calendar: FSCalendar,
                      appearance: FSCalendarAppearance,
                      eventSelectionColorsFor date: Date) -> [UIColor]? {

            guard hasCheckIn(date) else { return nil }
            return [UIColor.systemPink]
        }
        
        // MARK: - Private methods
        private func norm(_ date: Date) -> Date {
            cal.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? date
        }

        private func isMarked(_ date: Date) -> Bool {
            markedDays.contains(norm(date))
        }
        
        private func hasCheckIn(_ date: Date) -> Bool {
            checkInDays.contains(norm(date))
        }
    }
}
