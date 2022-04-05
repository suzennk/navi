//
//  OYODetailViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/12.
//

import Foundation

struct OYODetailViewModel {
    let title: String
    let verseRange: String
    let content: String
    
    init(verse: Verse) {
        self.title = verse.title.isEmpty ? verse.head : verse.title
        
        var rangeText = ""
        rangeText += "\(verse.bible) \(verse.chapter)장 \(verse.startVerse)"
        if let sym = verse.middleSymbol {
            rangeText += "\(sym)\(verse.endVerse)"
        }
        rangeText += "절"
        self.verseRange = rangeText
        self.content = verse.contents
    }
}
