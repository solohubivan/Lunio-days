//
//  MainTabView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    @State private var showUserProfile = false
    @State private var showPrivacyPolicy = false
    @State private var showTerms = false

    
    private let tabBarHeight: CGFloat = 96

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                contentView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBarView(selectedTab: $selectedTab)
                    .frame(height: tabBarHeight)
                    .background(Color.mainTabbar.ignoresSafeArea(edges: .bottom))
                    .clipShape(TopRoundedShape(radius: 35))
                    .shadow(color: .black.opacity(0.1), radius: 1, x: -1, y: -1,)
            }
            .ignoresSafeArea(edges: .bottom)
            .background(Color.white)
            .blur(radius: showUserProfile ? 3 : 0)
            
            if showUserProfile {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                UserProfileView {
                    showUserProfile = false
                }
                .transition(.identity)
                .zIndex(1)
            }
            
            // ✅ Privacy Policy overlay (БЕЗ blur)
            if showPrivacyPolicy {
                PrivacyPolicyView(onBack: {
                    showPrivacyPolicy = false
                })
                .transition(.opacity)
                .zIndex(20)
            }

            // ✅ Terms overlay (якщо потрібно окремо)
            if showTerms {
                TermsOfUseView(onBack: {
                    showTerms = false
                })
                .transition(.opacity)
                .zIndex(20)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showUserProfile)
        .animation(.easeInOut(duration: 0.25), value: showPrivacyPolicy)
        .animation(.easeInOut(duration: 0.25), value: showTerms)
    }

    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case 0:
            HomeScreenView()
        case 1:
            CalendarScreenView()
        case 2:
            CheckInMainScreenView()
        case 3:
            SettingsScreenView(
                onOpenProfile: { showUserProfile = true },
                onOpenPrivacyPolicy: { showPrivacyPolicy = true },
                onOpenTerms: { showTerms = true }
            )
        default:
            Color.black
        }
    }
}

private struct CustomTabBarView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            tabButton(systemImage: "homeTabbarIcon", index: 0)
            Spacer()
            tabButton(systemImage: "calendarTabbarIcon", index: 1)
            Spacer()
            tabButton(systemImage: "checkTabbarIcon", index: 2)
            Spacer()
            tabButton(systemImage: "settingTabbarIcon", index: 3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 26)
        .padding(.top, -20)
    }
    
    private func tabButton(
        systemImage: String,
        index: Int
    ) -> some View {
        Button {
            selectedTab = index
        } label: {
            ZStack {
                Circle()
                    .fill(
                        selectedTab == index
                        ? Color._111
                        : Color.tabbarChoosedItem
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                
                Image(systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environmentObject(UserSession())
}

// MARK: - helper
 fileprivate struct TopRoundedShape: Shape {
    var radius: CGFloat = 35

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
