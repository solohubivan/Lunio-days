//
//  TodaysCheckInView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct TodaysCheckInView: View {
    
    var body: some View {
        VStack {
            titleText
            currentDayInfo
                .padding(.vertical, 16)
        }
        .background(.clear)
    }
    
    private var titleText: some View {
        Text("Today's check-in")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
    }
    
    private var currentDayInfo: some View {
        VStack(spacing: 24) {
            TodaysCheckInCardView(
                title: "Mood",
                statement: "Good",
                imageName: "smile"
            )
            
            TodaysCheckInCardView(
                title: "Mood",
                statement: "Good",
                imageName: "smile"
            )
            
            TodaysCheckInCardView(
                title: "Mood",
                statement: "Good",
                imageName: "smile"
            )
        }
    }
}

#Preview {
    TodaysCheckInView()
}
