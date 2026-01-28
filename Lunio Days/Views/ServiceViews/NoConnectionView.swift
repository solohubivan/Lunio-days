//
//  NoConnectionView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct NoConnectionView: View {

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()
                mainImage
                titleText
                loadingAnimation
            }
            .padding(.bottom, 100)
        }
        .onAppear { isAnimating = true }
        .onDisappear { isAnimating = false }
    }

    private var mainImage: some View {
        Image("noConnection")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 40)
    }

    private var titleText: some View {
        Text("No connection")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.buttonStateText)
    }

    private var loadingAnimation: some View {
        ZStack {
            Image("loadingBackground")
                .resizable()
                .scaledToFit()
                .frame(width: 66, height: 66)

            Image("loadingProcess")
                .resizable()
                .scaledToFit()
                .frame(width: 66, height: 66)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 3).repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
    }
}

#Preview {
    NoConnectionView()
}
