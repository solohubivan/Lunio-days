//
//  Lunio_DaysApp.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI
import CoreData

@main
struct LunioDaysApp: App {

    @StateObject private var session = UserSession()
    @State private var isAppReady = false

    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isAppReady {
                    Group {
                        if hasCompletedOnboarding {
                            MainTabView()
                        } else {
                            AppDescribeScreenView()
                        }
                    }
                    .environmentObject(session)
                    .environment(\.managedObjectContext, CoreDataStack.shared.container.viewContext)
                    .transition(.opacity)
                } else {
                    LoadingScreenView {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isAppReady = true
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}
