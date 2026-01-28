//
//  App+Font.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

extension Font {
    
    static func petrona(_ weight: PetronaWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
    
    enum PetronaWeight: String {
        case bold = "Petrona-Bold"
    }
    
    static func phetsarath(_ weight: PhetsarathWeight, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
    
    enum PhetsarathWeight: String {
        case regular = "phetsarath-regular"
        case bold = "phetsarath-bold"
    }
}

