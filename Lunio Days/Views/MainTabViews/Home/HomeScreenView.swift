//
//  HomeScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import SwiftUI

struct HomeScreenView: View {
    
    var body: some View {
        VStack {
            calendar
            currentDate
            CurrentStateView()
                .background(Color.white)
                .cornerRadius(35)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                .padding(.horizontal, 20)
            
            checkInButton
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
        }
    }
    
    private var calendar: some View {
        WeekCalendarView()
            .frame(height: 85)
            .shadow(
                color: .black.opacity(0.1),
                radius: 2,
                x: 0,
                y: 2
            )
            .shadow(
                color: .black.opacity(0.15),
                radius: 2,
                x: 0,
                y: -1
            )
    }
    
    private var currentDate: some View {
        HStack {
            Text(formattedTodayDate)
                .font(.phetsarath(.regular, size: 24))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.leading, 20)
    }

    private var formattedTodayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    
    private var checkInButton: some View {
        Button {
            
        } label: {
            ZStack {
                LinearGradient(
                    colors: [Color._222, Color.juiceBlue, Color._111],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                HStack(spacing: 0) {
                    Image("pointIcon")
                        .resizable()
                        .scaledToFit()
                        .padding(25)
                    
                    Text("Complete today’s check-in")
                        .multilineTextAlignment(.leading)
                        .font(.phetsarath(.bold, size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(21)
                }
            }
            .frame(height: 85)
            .cornerRadius(30)
            .shadow(
                color: .black.opacity(0.25),
                radius: 2,
                x: 0,
                y: 2
            )
        }
    }
}

#Preview {
//    HomeScreenView()
    MainTabView()
        .environmentObject(UserSession())
}
