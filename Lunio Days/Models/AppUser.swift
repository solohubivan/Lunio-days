//
//  AppUser.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import Foundation

struct AppUser: Codable {
    var userImage: String
    var userName: String
    var periodDay: Bool
    var initialUserInfo: InitialUserInfo?
}

struct InitialUserInfo: Codable {
    var lastPeriodStarted: Date?
    var periodDuration: Int?
}
