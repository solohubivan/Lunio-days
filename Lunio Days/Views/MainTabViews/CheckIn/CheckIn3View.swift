//
//  CheckIn3View.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI

struct CheckIn3View: View {
    
    let onBack: () -> Void
    let onFinish: () -> Void

    @State private var selectedIndex: Int? = nil

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                topBar
                Spacer()
                progress
                Spacer()
                titleLabel
                Spacer()
                inputButtons
                    .padding(.horizontal, 40)
                nextButton
                    .padding(.horizontal, 20)
                    .padding(.vertical, 45)
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            CircularBackButton(action: onBack)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
    
    private var progress: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let progressFraction: CGFloat = 3.0 / 3.0
            let progressWidth = totalWidth * progressFraction

            ZStack(alignment: .leading) {

                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color._222.opacity(0.4), lineWidth: 1)

                ZStack {
                    LinearGradient(
                        colors: [
                            Color._222,
                            Color._333
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )

                    Text("3/3")
                        .font(.phetsarath(.regular, size: 12))
                        .foregroundColor(Color.buttonStateText)
                }
                .frame(width: progressWidth)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }
        .frame(height: 19)
        .padding(.horizontal, 40)
    }

    private var titleLabel: some View {
        Text(makeHighlightedText(fullText: "How much energy do you have today?", baseColor: .brownText, highlights: ["energy": ._111])
        )
        .font(.petrona(.bold, size: 32))
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20)
    }
    
    private var inputButtons: some View {
        VStack(spacing: 25) {
            CheckInChoiceButton(
                imageName: "smile",
                title: "A lot",
                index: 0,
                selectedIndex: selectedIndex,
                onSelect: { selectedIndex = $0 }
            )

            CheckInChoiceButton(
                imageName: "okSmile",
                title: "Some",
                index: 1,
                selectedIndex: selectedIndex,
                onSelect: { selectedIndex = $0 }
            )

            CheckInChoiceButton(
                imageName: "sadSmile",
                title: "Very little",
                index: 2,
                selectedIndex: selectedIndex,
                onSelect: { selectedIndex = $0 }
            )
        }
    }
    
    private var nextButton: some View {
        Button("Finish") {
            onFinish()
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }
}

#Preview {
    CheckIn3View(onBack: {
        print("Back tapped")
    }, onFinish: {
        print("Finish tapped")
    })
}
