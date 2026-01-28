//
//  MakeHighlightedText.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 20.01.2026.
//

import SwiftUI

func makeHighlightedText(
    fullText: String,
    baseColor: Color,
    highlights: [String: Color]
) -> AttributedString {

    var attributed = AttributedString(fullText)
    attributed.foregroundColor = baseColor

    for (word, color) in highlights {
        var searchRange = attributed.startIndex..<attributed.endIndex

        while searchRange.lowerBound < attributed.endIndex {
            let sub = attributed[searchRange]

            guard let foundInSub = sub.range(of: word) else { break }

            let lower = foundInSub.lowerBound
            let upper = foundInSub.upperBound
            let foundRange = lower..<upper

            attributed[foundRange].foregroundColor = color
            
            searchRange = foundRange.upperBound..<attributed.endIndex
        }
    }

    return attributed
}
