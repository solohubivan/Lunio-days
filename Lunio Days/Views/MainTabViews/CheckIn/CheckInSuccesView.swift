//
//  CheckInSucces.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct CheckInSuccesView: View {
    
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack {
                Spacer()
                mainImage
                infoText
                    .padding(.vertical, 80)
                doneButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 45)
        }
        .task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            onDone()
        }
    }
    
    private var mainImage: some View {
        Image("successIcon")
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 100)
    }
    
    private var infoText: some View {
        VStack(spacing: 10) {
            Text("Saved")
                .font(.phetsarath(.bold, size: 32))
                .foregroundColor(.brownText)
            
            Text("Taking a moment to check in can be really helpful")
                .font(.phetsarath(.regular, size: 20))
                .foregroundColor(.brownText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            onDone()
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }
}

#Preview {
    CheckInSuccesView(onDone: {
        print("done pressed")
    })
}
