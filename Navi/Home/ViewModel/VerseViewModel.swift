//
//  VerseViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import Foundation

struct VerseViewModel {
    let content: String
    let rangeText: String
    let text: String
    
    init(_ verse: Verse) {
        var rangeText = ""
        rangeText += "\(verse.bible) \(verse.chapter):\(verse.startVerse)"
        if let _ = verse.middleSymbol {
            // use "-" instead of original
            rangeText += "-\(verse.endVerse)"
        }
        
        var text = ""
        text += "\(verse.contents)"
        self.content = text
        
        text += "(\(rangeText))"
        
        self.rangeText = rangeText
        self.text = text
    }
}

