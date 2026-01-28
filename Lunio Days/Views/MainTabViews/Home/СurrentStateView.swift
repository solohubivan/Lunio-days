//
//  СurrentStateView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct CurrentStateView: View {
    
    @EnvironmentObject private var session: UserSession

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
               Image(session.user.periodDay ? "periodDayForm" : "cycleDayForm")
                   .resizable()
                   .scaledToFit()
                   .padding(.horizontal, 60)
                   .padding(.leading, 20)

               Text(session.user.periodDay ? "Period day" : "Cycle day")
                   .font(.phetsarath(.bold, size: 24))
                   .foregroundColor(session.user.periodDay ? .white : .buttonStateText)
           }
       }

    private var setPeriodButton: some View {
        Button {
            if session.user.periodDay {
                session.stopPeriod()
            } else {
                session.startPeriod()
            }
        } label: {
            Text(session.user.periodDay ? "End period" : "Start period")
                .font(.phetsarath(.bold, size: 16))
                .foregroundColor(session.user.periodDay ? .buttonStateText : .white)
                .padding(.horizontal, 30)
                .frame(height: 50)
                .background(periodButtonGradient)
                .cornerRadius(30)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 30)
        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
    }
    
    private var periodButtonGradient: LinearGradient {
        if session.user.periodDay {
            return LinearGradient(
                colors: [
                    Color._222,
                    Color._333
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color._111,
                    Color._111.opacity(0.6)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

#Preview {
//    CurrentStateView()
    MainTabView()
        .environmentObject(UserSession())
}
