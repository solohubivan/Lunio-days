//
//  CheckInMainScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI

struct CheckInMainScreenView: View {
    
    @State private var showFlow = false

    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            VStack {
                StartCheckInView()
//                TodaysCheckInView()
                    .padding(.bottom, 40)
                confirmButton
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $showFlow) {
            CheckInFlowView()
        }
    }
    
    private var confirmButton: some View {
            Button("Start check-in") {
                showFlow = true
            }
            .font(.phetsarath(.bold, size: 20))
            .buttonStyle(FullWidthButtonStyle())
            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        }
}

#Preview {
    MainTabView()
        .environmentObject(UserSession())
}
