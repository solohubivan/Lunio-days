//
//  OnboardingQuestionsScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct OnboardingQuestionsScreenView: View {

    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var session: UserSession

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @StateObject private var vm = OnboardingQuestionsViewModel()

    var body: some View {
        ZStack {
            if vm.showMainTab {
                MainTabView()
                    .transition(.opacity)
            } else {
                onboardingContent
            }
        }
        .animation(.easeInOut(duration: 0.35), value: vm.showMainTab)
    }

    private var onboardingContent: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Spacer()
                currentPage
                    .padding(.horizontal, 20)
                    .padding(.bottom, 35)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomSlot
                .ignoresSafeArea(edges: .horizontal)
                .padding(.bottom, 10)
        }
        .animation(.bouncy(duration: 0.6), value: vm.pageIndex)
    }

    private var currentPage: some View {
        Group {
            switch vm.pageIndex {
            case 0:
                LastPeriodStartPickerView(
                    selectedDay: $vm.selectedDay,
                    selectedMonth: $vm.selectedMonth
                )
            case 1:
                PeriodsDurationPickerView(
                    selectedDurationIndex: $vm.selectedDurationIndex
                )
            case 2:
                AvarageCycleDaysPickerView()
            default:
                EmptyView()
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
        .id(vm.pageIndex)
    }

    private var bottomSlot: some View {
        VStack(spacing: 16) {
            notSureButton
            nextButton
                .padding(.bottom, 20)
            PageDotsIndicatorView(total: 3, selectedIndex: vm.pageIndex)
        }
        .padding(.horizontal, 20)
    }

    private var nextButton: some View {
        Button(vm.nextButtonTitle) {
            vm.onNextTap(
                context: context,
                session: session,
                setHasCompletedOnboarding: { hasCompletedOnboarding = $0 }
            )
        }
        .font(.phetsarath(.bold, size: 24))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }

    private var notSureButton: some View {
        Button("Not sure") {
            vm.onNotSureTap(
                context: context,
                session: session,
                setHasCompletedOnboarding: { hasCompletedOnboarding = $0 }
            )
        }
        .font(.phetsarath(.regular, size: 20))
        .buttonStyle(OutlineButtonStyle())
    }
}

#Preview {
    OnboardingQuestionsScreenView()
        .environment(\.managedObjectContext, CoreDataStack.shared.context)
        .environmentObject(UserSession())
}
