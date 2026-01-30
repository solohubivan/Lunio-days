//
//  UserSession.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 23.01.2026.
//

import Foundation
import Combine
import UIKit

@MainActor
final class UserSession: ObservableObject {

    @Published private(set) var user: AppUser

    private let storageKey = "current_user_v1"
    private let avatarFileName = "user_avatar.jpg"

    init() {
        if let saved = Self.load(from: storageKey) {
            self.user = saved
        } else {
            self.user = AppUser(
                userImage: "defaultUserImage",
                userName: "Username",
                periodDay: false,
                initialUserInfo: nil
            )
            Self.save(self.user, to: storageKey)
        }
    }
    
    func updateLastPeriodStarted(_ date: Date?) {
        if user.initialUserInfo == nil {
            user.initialUserInfo = InitialUserInfo(
                lastPeriodStarted: nil,
                periodDuration: nil
            )
        }

        user.initialUserInfo?.lastPeriodStarted = date
        Self.save(user, to: storageKey)
    }

    func updatePeriodDuration(_ value: Int?) {
        if user.initialUserInfo == nil {
            user.initialUserInfo = InitialUserInfo(
                lastPeriodStarted: nil,
                periodDuration: nil
            )
        }
        user.initialUserInfo?.periodDuration = value
        Self.save(user, to: storageKey)
    }
    
    func startPeriod() {
        user.periodDay = true
        Self.save(user, to: storageKey)
    }

    func stopPeriod() {
        user.periodDay = false
        Self.save(user, to: storageKey)
    }
    
    func updateUserName(_ name: String) {
        user.userName = name
        Self.save(user, to: storageKey)
    }
    
    func updateAvatar(with image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        do {
            let url = try avatarURL()
            try data.write(to: url, options: [.atomic])
            user.userImage = avatarFileName
            Self.save(user, to: storageKey)
        } catch {
            
        }
    }
    
    func loadAvatarImage() -> UIImage? {
        if user.userImage == "defaultUserImage" { return nil }
        
        do {
            let url = try avatarURL()
            return UIImage(contentsOfFile: url.path)
        } catch {
            return nil
        }
    }

    // MARK: - Storage
    private static func load(from key: String) -> AppUser? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(AppUser.self, from: data)
    }

    private static func save(_ user: AppUser, to key: String) {
        let data = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    // MARK: - private helper
    private func avatarURL() throws -> URL {
        let dir = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return dir.appendingPathComponent(avatarFileName)
    }
}
