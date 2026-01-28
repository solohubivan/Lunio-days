//
//  Lunio_DaysApp.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

//import SwiftUI
//
//@main
//struct LunioDaysApp: App {
//    
//    @StateObject private var session = UserSession()
//    @State private var isAppReady = false
//    
//    var body: some Scene {
//        WindowGroup {
//            ZStack {
//                if isAppReady {
////                    MainTabView()
//                    AppDescribeScreenView()
//                        .environmentObject(session)
//                        .transition(.opacity)
//                } else {
//                    LoadingScreenView {
//                        withAnimation(.easeInOut(duration: 0.25)) {
//                            isAppReady = true
//                        }
//                    }
//                    .transition(.opacity)
//                }
//            }
//        }
//    }
//}
import SwiftUI

@main
struct LunioDaysApp: App {

    @StateObject private var session = UserSession()
    @State private var isAppReady = false

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

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
