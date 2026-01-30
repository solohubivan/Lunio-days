//
//  СurrentStateView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct CurrentStateView: View {

    let isPeriodDay: Bool
    let onStartPeriod: () -> Void
    let onEndPeriod: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            stateImage
            setPeriodButton
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
    }

    private var stateImage: some View {
        ZStack {
            Image(isPeriodDay ? "periodDayForm" : "cycleDayForm")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 60)
                .padding(.leading, 20)

            Text(isPeriodDay ? "Period day" : "Cycle day")
                .font(.phetsarath(.bold, size: 24))
                .foregroundColor(isPeriodDay ? .white : .buttonStateText)
        }
    }

    private var setPeriodButton: some View {
        Button {
            if isPeriodDay {
                onEndPeriod()
            } else {
                onStartPeriod()
            }
        } label: {
            Text(isPeriodDay ? "End period" : "Start period")
                .font(.phetsarath(.bold, size: 16))
                .foregroundColor(isPeriodDay ? .buttonStateText : .white)
                .padding(.horizontal, 35)
                .frame(height: 50)
                .background(periodButtonGradient)
                .cornerRadius(30)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 30)
        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
    }

    private var periodButtonGradient: LinearGradient {
        if isPeriodDay {
            return LinearGradient(colors: [Color._222, Color._333], startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(colors: [Color._111, Color._111.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
        }
    }
}
