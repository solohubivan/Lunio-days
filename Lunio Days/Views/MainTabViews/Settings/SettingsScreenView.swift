//
//  SettingsScreenView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct SettingsScreenView: View {
    
    @EnvironmentObject private var session: UserSession

    let onOpenProfile: () -> Void
    let onOpenPrivacyPolicy: () -> Void
    let onOpenTerms: () -> Void
    
    @AppStorage("soundEnabled") private var soundEnabled: Bool = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                titleText
                userProfile
                    .padding(.top, 16)
                Spacer()
                soundSetting
                Spacer()
                bottomButtons
            }
            .padding(.vertical, 40)
        }
    }

    private var titleText: some View {
        HStack {
            Text("Settings")
                .font(.petrona(.bold, size: 32))
                .foregroundColor(.brownText)
            Spacer()
        }
        .padding(.leading, 23)
    }
    
    private var userProfile: some View {
        Button {
            onOpenProfile()
        } label: {
            VStack(spacing: 0) {
                ZStack {
                    Image("profileBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 164, height: 164)

                    if let image = session.loadAvatarImage() {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 152, height: 152)
                            .clipShape(Circle())
                    }
                }

                Text(session.user.userName)
                    .font(.phetsarath(.bold, size: 16))
                    .foregroundColor(.brownText)
            }
        }
        .buttonStyle(.plain)
    }

    private var soundSetting: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 57)
                .stroke(Color._222, lineWidth: 1)
                .frame(height: 56)

            HStack {
                Text("Sound")
                    .font(.phetsarath(.bold, size: 16))
                    .foregroundColor(.brownText)
                    .padding(.leading, 23)

                Spacer()

                CircleSwitch(isOn: $soundEnabled)
                    .padding(.trailing, 8)
            }
        }
        .padding(.horizontal, 23)
    }

    private var bottomButtons: some View {
        VStack(spacing: 15) {
            Button("Terms of USE") { onOpenTerms() }
                .font(.phetsarath(.bold, size: 20))
                .buttonStyle(FullWidthButtonStyle())
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

            Button("Privacy Policy") { onOpenPrivacyPolicy() }
                .font(.phetsarath(.bold, size: 20))
                .buttonStyle(FullWidthButtonStyle())
                .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        }
        .padding(.horizontal, 23)
    }
}

#Preview {
    SettingsScreenView(onOpenProfile: {
        print("")
    }, onOpenPrivacyPolicy: {
        print("")
    }, onOpenTerms: {
        print("")
    })
    .environmentObject(UserSession())
}
