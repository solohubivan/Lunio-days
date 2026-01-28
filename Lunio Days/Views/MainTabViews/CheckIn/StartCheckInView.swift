//
//  StartCheckInView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 26.01.2026.
//

import SwiftUI

struct StartCheckInView: View {
    
    var body: some View {
        VStack {
            titleText
            mainImage
                .padding(.vertical, 20)
            chekInStatusText
            recomendsText
                .padding(.top, 5)
        }
        .background(Color.clear)
    }
    
    private var titleText: some View {
        Text("Today's check-in")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
    }
    
    private var mainImage: some View {
        Image("image60")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 35)
    }
    
    private var chekInStatusText: some View {
        Text("Today’s check-in is missing")
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
    }
    
    private var recomendsText: some View {
        Text("Take a moment to complete it")
            .font(.phetsarath(.regular, size: 20))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
    }
}

#Preview {
    StartCheckInView()
//    MainTabView()
//        .environmentObject(UserSession())
}
