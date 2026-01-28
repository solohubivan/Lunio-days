//
//  Month.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 22.01.2026.
//

enum Month: Int, CaseIterable, Identifiable {
    case january = 1, february, march, april, may, june, july, august, september, october, november, december

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .january: return "January"
        case .february: return "February"
        case .march: return "March"
        case .april: return "April"
        case .may: return "May"
        case .june: return "June"
        case .july: return "July"
        case .august: return "August"
        case .september: return "September"
        case .october: return "October"
        case .november: return "November"
        case .december: return "December"
        }
    }

    var daysCount: Int {
        switch self {
        case .january, .march, .may, .july, .august, .october, .december:
            return 31
        case .april, .june, .september, .november:
            return 30
        case .february:
            return 28
        }
    }
}
