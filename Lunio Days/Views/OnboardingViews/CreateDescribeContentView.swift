//
//  CreateDescribeContentView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

struct CreateDescribeContentView: View {
    
    var imageName: String
    var titleText: AttributedString
    var bodyText: String
    
    var body: some View {
        VStack {
            mainImage
            titleLabel
            infoLabel
        }
        .background(Color.clear)
    }
    
    private var mainImage: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
    }
    
    private var titleLabel: some View {
        Text(titleText)
            .font(.petrona(.bold, size: 32))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
            .padding(.top, 30)
    }
    
    private var infoLabel: some View {
        Text(bodyText)
            .font(.custom("phetsarath-regular", size: 20))
            .foregroundColor(.brownText)
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
    }
}

#Preview {
    CreateDescribeContentView(
        imageName: "onb1pic",
        titleText: "Keep track of your\n cycle",
        bodyText: "Easily record your period \ndays and view them in \none place"
    )
}
