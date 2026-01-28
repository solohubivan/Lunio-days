//
//  TodaysCheckInCardView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct TodaysCheckInCardView: View {

    let title: String
    let statement: String
    let imageName: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.phetsarath(.bold, size: 24))
                    .foregroundColor(Color._111)
                
                Text(statement)
                    .font(.phetsarath(.regular, size: 16))
                    .foregroundColor(.brownText)
            }
            
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)
        }
        .padding(.horizontal, 16)
        .frame(height: 116)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 9)
                .stroke(Color._222, lineWidth: 1)
        )
        .cornerRadius(9)
        .shadow(
            color: .black.opacity(0.25),
            radius: 4,
            x: 0,
            y: 2
        )
    }
}
