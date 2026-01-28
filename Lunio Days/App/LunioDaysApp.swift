//
//  Lunio_DaysApp.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

@main
struct LunioDaysApp: App {
    
    @StateObject private var session = UserSession()
    
    var body: some Scene {
        WindowGroup {
//            AppDescribeScreenView()
            MainTabView()
                .environmentObject(session)
        }
    }
}
