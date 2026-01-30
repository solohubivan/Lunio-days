//
//  CheckInModels.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 29.01.2026.
//

import Foundation

enum Mood: Int16, CaseIterable {
    case good = 0
    case okay = 1
    case bad  = 2

    var title: String {
        switch self {
        case .good: "Good"
        case .okay: "Okay"
        case .bad:  "Bad"
        }
    }

    var imageName: String {
        switch self {
        case .good: "smile"
        case .okay: "okSmile"
        case .bad:  "sadSmile"
        }
    }
}

enum PainLevel: Int16, CaseIterable {
    case noPain = 0
    case mild   = 1
    case strong = 2

    var title: String {
        switch self {
        case .noPain: "No pain"
        case .mild:   "Mild pain"
        case .strong: "Strong pain"
        }
    }

    var imageName: String {
        switch self {
        case .noPain: "smile"
        case .mild:   "okSmile"
        case .strong: "sadSmile"
        }
    }
}

enum EnergyLevel: Int16, CaseIterable {
    case aLot      = 0
    case some      = 1
    case veryLittle = 2

    var title: String {
        switch self {
        case .aLot:       "A lot"
        case .some:       "Some"
        case .veryLittle: "Very little"
        }
    }

    var imageName: String {
        switch self {
        case .aLot:       "smile"
        case .some:       "okSmile"
        case .veryLittle: "sadSmile"
        }
    }
}


extension Mood {
    init?(rawOrNil value: Int16) { self.init(rawValue: value) }
}

extension PainLevel {
    init?(rawOrNil value: Int16) { self.init(rawValue: value) }
}

extension EnergyLevel {
    init?(rawOrNil value: Int16) { self.init(rawValue: value) }
}
