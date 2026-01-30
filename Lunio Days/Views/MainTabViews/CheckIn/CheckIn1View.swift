//
//  CheckIn1View.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI

struct CheckIn1View: View {
    
    @Binding var selectedMood: Mood?
    
    let onBack: () -> Void
    let onNext: () -> Void

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
            let progressFraction: CGFloat = 1.0 / 3.0
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

                    Text("1/3")
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
        Text(makeHighlightedText(
            fullText: "How are you feeling today?",
            baseColor: .brownText,
            highlights: ["feeling": ._111])
        )
        .font(.petrona(.bold, size: 32))
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 20)
    }
    
    private var inputButtons: some View {
        VStack(spacing: 25) {
            ForEach(Mood.allCases, id: \.rawValue) { item in
                CheckInChoiceButton(
                    imageName: item.imageName,
                    title: item.title,
                    index: Int(item.rawValue),
                    selectedIndex: selectedMood.map { Int($0.rawValue) },
                    onSelect: { _ in selectedMood = item }
                )
            }
        }
    }
    
    private var nextButton: some View {
        let isDisabled = (selectedMood == nil)

        return Button("Next") {
            onNext()
        }
        .disabled(isDisabled)
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(
            FullWidthButtonStyle(
                backgroundColor: isDisabled ? Color.gray.opacity(0.2) : nil,
                gradientTextColor: .buttonStateText,
                solidTextColor: .white
            )
        )
        .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var mood: Mood? = nil

    var body: some View {
        CheckIn1View(
            selectedMood: $mood,
            onBack: {
                print("Back tapped")
            },
            onNext: {
                print("Next tapped, mood:", mood as Any)
            }
        )
    }
}
