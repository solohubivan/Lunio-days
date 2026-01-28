//
//  PeriodsDurationPickerView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct PeriodsDurationPickerView: View {

    @Binding var selectedDurationIndex: Int
    
    @State private var scrollTrigger: Int = 0
    
    private let dayItems: [String] = (1...14).map(String.init)
    
    var body: some View {
        VStack {
            titleLabel

            ZStack {
                Color.datePickerGray
                    .frame(height: 25)
                    .cornerRadius(4)
                
                CustomWheelPicker(
                    items: dayItems,
                    selectedIndex: $selectedDurationIndex,
                    rowHeight: 26,
                    visibleRows: 5,
                    font: .phetsarath(.bold, size: 18),
                    textColor: .brownText,
                    selectedFont: .phetsarath(.bold, size: 24),
                    selectedColor: .black,
                    dimmedOpacity: 0.25,
                    scrollTrigger: scrollTrigger
                )
            }
            .padding(.vertical, 80)
            
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            DispatchQueue.main.async {
                if selectedDurationIndex == 0 {
                    selectedDurationIndex = 3
                }
                scrollTrigger += 1
            }
        }
    }

    private var titleLabel: some View {
        Text(makeHighlightedText(
            fullText: "How many days do your periods ussually last?",
            baseColor: .brownText,
            highlights: ["days": ._111]))
            .font(.petrona(.bold, size: 32))
            .multilineTextAlignment(.center)
    }
}

//#Preview {
//    PeriodsDurationPickerView()
//}
