//
//  AppSounds.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 30.01.2026.
//

import SwiftUI
import Foundation
import AudioToolbox

enum AppSounds {

    private static let tapSoundId: SystemSoundID = 1104

    private static var lastPlayTime: CFTimeInterval = 0
    private static let minInterval: CFTimeInterval = 0.05

    static func playTapIfAllowed(_ enabled: Bool) {
        guard enabled else { return }

        let now = CACurrentMediaTime()
        guard now - lastPlayTime >= minInterval else { return }
        lastPlayTime = now

        AudioServicesPlaySystemSound(tapSoundId)
    }
}
