//
//  UserProfileView.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 27.01.2026.
//

import SwiftUI

struct UserProfileView: View {

    let onClose: () -> Void
    
    @EnvironmentObject private var session: UserSession
    
    @State private var isPhotoMenuPresented: Bool = false
    @State private var isPhotoPickerPresented: Bool = false
    @State private var isCameraPresented: Bool = false

    @State private var username: String = ""
    @State private var pickedAvatar: UIImage? = nil
    
    

    var body: some View {
        ZStack {
            
            VStack {
                topBar

                userSettingsBackground
                    .padding(.top, 100)

                if !isPhotoMenuPresented {
                    saveButton
                        .padding(.top, 45)
                }

                Spacer()
            }
            .padding(.horizontal, 24)

            if isPhotoMenuPresented {
                VStack {
                    Spacer()
                    bottomMenu
                        .transition(.opacity)
                }
                .zIndex(2)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .animation(.easeInOut(duration: 0.25), value: isPhotoMenuPresented)
        .sheet(isPresented: $isPhotoPickerPresented) {
            AvatarPickerSheet { image in
                pickedAvatar = image
                isPhotoPickerPresented = false
            }
        }
        .fullScreenCover(isPresented: $isCameraPresented) {
            CameraPicker { image in
                pickedAvatar = image
                isCameraPresented = false
            }
            .ignoresSafeArea()
        }
        .task {
            username = session.user.userName
            pickedAvatar = session.loadAvatarImage()
        }
    }

    // MARK: - UI components
    private var topBar: some View {
        HStack {
            CircularBackButton(action: onClose)
            Spacer()
        }
        .padding(.top, 20)
    }
    
    private var userSettingsBackground: some View {
        VStack(spacing: 30) {
            userAvatar
            usernameField
                .padding(.bottom, 61)
                .padding(.horizontal, 33)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
    
    private var userAvatar: some View {
        Button { isPhotoMenuPresented = true } label: {
            ZStack {
                Image("avatarForm")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 51)
                    .frame(width: 230)

                if let pickedAvatar {
                    Image(uiImage: pickedAvatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 220, height: 220)
                        .clipShape(Circle())
                        .padding(.top, 51)
                } else if session.user.userImage == "defaultUserImage" {
                    
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private var usernameField: some View {
        HStack {
            TextField(
                text: $username,
                prompt: Text("Username")
                    .foregroundColor(._22)
                    .font(.phetsarath(.bold, size: 16))
            ) { }
            .submitLabel(.done)
            .keyboardType(.default)
            .textContentType(.name)
            .textInputAutocapitalization(.words)
            .onChange(of: username) { newValue in
                if newValue.count > 25 {
                    username = String(newValue.prefix(25))
                }
            }
            
            Image("editIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 17)
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 57)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 57)
                .stroke(Color._22, lineWidth: 1)
        )
    }

    private var saveButton: some View {
        Button("Save") {
            session.updateUserName(username)

            if let pickedAvatar {
                session.updateAvatar(with: pickedAvatar)
            }

            onClose()
        }
        .font(.phetsarath(.bold, size: 20))
        .buttonStyle(FullWidthButtonStyle())
        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
    }
    
    private var bottomMenu: some View {
        VStack(spacing: 14) {
            Button("make a photo") {
                isPhotoMenuPresented = false
                isCameraPresented = true
            }
            .font(.phetsarath(.regular, size: 16))
            .buttonStyle(FullWidthButtonStyle(height: 32))
            .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
            .padding(.horizontal, 26)
            .padding(.top, 10)

            Button("choose a photo") {
                isPhotoMenuPresented = false
                isPhotoPickerPresented = true
            }
            .font(.phetsarath(.regular, size: 16))
            .buttonStyle(FullWidthButtonStyle(height: 32))
            .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
            .padding(.horizontal, 26)

            Button("CANCEL") {
                isPhotoMenuPresented = false
            }
            .font(.phetsarath(.regular, size: 16))
            .foregroundColor(.buttonStateText)
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(
                RoundedRectangle(cornerRadius: 57)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 57)
                    .stroke(Color._222, lineWidth: 1)
            )
            .padding(.horizontal, 26)
            
            Spacer()
            
        }
        .padding(.top, 18)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .frame(height: 178)
        .background(
            Color.white
                .clipShape(TopCornersRoundedShape(radius: 26))
                .shadow(color: .black.opacity(0.25), radius: 4, x: -1, y: -1)
        )
    }
}

#Preview {
    UserProfileView(onClose: {
        print("close")
    }).environmentObject(UserSession())
}

// MARK: - helper
struct TopCornersRoundedShape: Shape {
    var radius: CGFloat = 26

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
