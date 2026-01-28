//
//  LoadingScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 28.01.2026.
//

import SwiftUI

struct LoadingScreenView: View {
    
    let onFinished: () -> Void

    @State private var progress: Double = 0
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 5) {
                Spacer()
                mainImage
                loadingText
                    .padding(.top, 57)
                loadingAnimation
            }
            .padding(.bottom, 70)
        }
        .onAppear {
            startProgress()
        }
        .onDisappear {
            stopProgress()
        }
    }

    private var mainImage: some View {
        Image("loadingPic")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 40)
    }

    private var loadingText: some View {
        Text("Loading")
            .font(.phetsarath(.regular, size: 24))
            .foregroundColor(.brownText)
    }

    private var loadingAnimation: some View {
        ZStack {
            Image("loadingBackground")
                .resizable()
                .scaledToFit()
                .frame(width: 116, height: 116)

            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color._333, Color._222]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.03), value: progress)

            Text("\(Int(progress))%")
                .font(.phetsarath(.regular, size: 24))
                .foregroundColor(.brownText)
                .monospacedDigit()
        }
    }

    private func startProgress() {
        stopProgress()
        progress = 0

        let duration: Double = 2.0
        let steps: Double = 100
        let interval = duration / steps

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            if progress >= 100 {
                progress = 100
                t.invalidate()
                timer = nil
                
                DispatchQueue.main.async {
                    onFinished()
                }
                
                return
            }
            progress += 1
        }
    }

    private func stopProgress() {
        timer?.invalidate()
        timer = nil
        progress = 0
    }
}

#Preview {
    LoadingScreenView(onFinished: {
        print("")
    })
}
