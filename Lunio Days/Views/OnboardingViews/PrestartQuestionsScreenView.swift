//
//  PrestartQuestionsScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct PrestartQuestionsScreenView: View {
    
    @State private var showOnboardingQuestionsViewScreen: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 60) {
                    Spacer()
                    titleText
                    bodyText
                    mainImage
                    Spacer()
                }
            }
            .safeAreaInset(edge: .bottom) {
                startButton
                    .ignoresSafeArea(edges: .horizontal)
                    .padding(.bottom, 58)
            }
            
            if showOnboardingQuestionsViewScreen {
                OnboardingQuestionsScreenView()
                    .transition(.opacity.animation(.smooth))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showOnboardingQuestionsViewScreen)
    }
    
    private var titleText: some View {
        Text(makeHighlightedText(
            fullText: "Before we begin",
            baseColor: .brownText,
            highlights: ["begin": ._111])
        )
        .font(.custom("Petrona-Bold", size: 32))
        .multilineTextAlignment(.center)
    }
    
    private var bodyText: some View {
        Text("Answer a few short questions\nto set up your calendar")
            .font(.custom("phetsarath-regular", size: 20))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
    }
    
    private var mainImage: some View {
        Image("onb4pic")
            .resizable()
            .scaledToFit()
    }
    
    private var startButton: some View {
        Button("Start") {
            showOnboardingQuestionsViewScreen = true
        }
        .font(.custom("phetsarath-bold", size: 24))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        .padding(.horizontal, 20)
    }
}

#Preview {
    PrestartQuestionsScreenView()
}
