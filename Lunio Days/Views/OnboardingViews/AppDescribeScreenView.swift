//
//  AppDescribeScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct AppDescribeScreenView: View {

    @State private var pageIndex = 0
    @State private var showPrestart = false
    
    private let pages: [DescribePage] = [
        .init(
            imageName: "onb1pic",
            title: makeHighlightedText(
                fullText: "Keep track of your\ncycle",
                baseColor: .brownText,
                highlights: ["track": ._111]
            ),
            body: "Easily record your period\ndays and view them in\none place"
        ),
        .init(
            imageName: "onb2pic",
            title: makeHighlightedText(
                fullText: "See everything at a\nglance",
                baseColor: .brownText,
                highlights: ["everything": ._111]
            ),
            body: "Your cycle history is shown\nin a clear, easy-to-read\ncalendar"
        ),
        .init(
            imageName: "onb3pic",
            title: makeHighlightedText(
                fullText: "Track how you\nfeel",
                baseColor: .brownText,
                highlights: ["feel": ._111]
            ),
            body: "Optionally log your mood\nand well-being during\nyour cycle"
        )
    ]
    
    
    var body: some View {
        ZStack {
            mainOnboarding

            if showPrestart {
                PrestartQuestionsScreenView()
                    .transition(.opacity.animation(.smooth))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showPrestart)
    }

    private var mainOnboarding: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                currentContent
                    .padding(.horizontal, 16)
                    .padding(.bottom, 35)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !showPrestart {
                bottomSlot
                    .ignoresSafeArea(edges: .horizontal)
                    .padding(.bottom, 10)
            }
        }
    }

    private var currentContent: some View {
        let page = pages[pageIndex]
        return CreateDescribeContentView(
            imageName: page.imageName,
            titleText: page.title,
            bodyText: page.body
        )
        .transition(.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        ))
        .id(pageIndex)
        .animation(.bouncy(duration: 0.6), value: pageIndex)
    }

    private var bottomSlot: some View {
        VStack(spacing: 36) {
            nextButton
                .padding(.horizontal, 20)

            PageDotsIndicatorView(total: pages.count, selectedIndex: pageIndex)
        }
    }

    private var nextButton: some View {
        Button("Next") {
            onNextTap()
        }
        .font(.phetsarath(.bold, size: 24))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }

    private func onNextTap() {
        //тут гард юзай
        if pageIndex < pages.count - 1 {
            pageIndex += 1
        } else {
            showPrestart = true
        }
    }
}

private struct DescribePage {
    let imageName: String
    let title: AttributedString
    let body: String
}


#Preview {
    AppDescribeScreenView()
}
