//
//  OnboardingQuestionsScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct OnboardingQuestionsScreenView: View {
    
    @State private var pageIndex = 0
    
    @State private var selectedDay: Int = 0
    @State private var selectedMonth: Int = 0
    
    var body: some View {
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
            .animation(.bouncy(duration: 0.6), value: pageIndex)
        }
    
    private var currentPage: some View {
        Group {
            switch pageIndex {
            case 0:
                LastPeriodStartPickerView(
                    selectedDay: $selectedDay,
                    selectedMonth: $selectedMonth
                )

            case 1:
                PeriodsDurationPickerView()
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
        .id(pageIndex)
    }
    
    private var bottomSlot: some View {
        VStack(spacing: 16) {
            notSureButton
            nextButton
                .padding(.bottom, 20)
            PageDotsIndicatorView(total: 3, selectedIndex: pageIndex)
        }
        .padding(.horizontal, 20)
    }
    
    private var isLastPage: Bool {
        pageIndex == 2
    }

    private var nextButtonTitle: String {
        isLastPage ? "Finish" : "Next"
    }

    private var nextButton: some View {
        Button(nextButtonTitle) {
            onNextTap()
        }
        .font(.phetsarath(.bold, size: 24))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }

    private func onNextTap() {
        if isLastPage {
            // finish action тут
            // наприклад: print("Finish")
        } else {
            pageIndex += 1
        }
    }
    
//    private var nextButton: some View {
//        Button("Next") {
//            let month = Month.allCases[selectedMonth].title
//            let day = selectedDay + 1
//            
//            print("Вибрана дата: \(day) \(month)")
//            onNextTap()
//        }
//        .font(.phetsarath(.bold, size: 24))
//        .buttonStyle(FullWidthButtonStyle())
//        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
//    }
    
//    private func onNextTap() {
//        if pageIndex < 2 {
//            pageIndex += 1
//        }
//    }
    
    private var notSureButton: some View {
        Button("Not sure") {
            
        }
        .font(.phetsarath(.regular, size: 20))
        .buttonStyle(OutlineButtonStyle())
    }
}

#Preview {
    OnboardingQuestionsScreenView()
}
