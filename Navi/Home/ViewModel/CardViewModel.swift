//
//  CardViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

import Foundation

struct CardViewModel {
    let title: String
    let verseRange: String
    let content: String
    let head: String
    let subhead: String
    
    init(_ verse: Verse) {
        if verse.title != "" {
            self.title = verse.title
        } else {
            self.title = verse.head
        }
        
        var versesText = "\(verse.bible) \(verse.chapter):\(verse.startVerse)"
        if let sym = verse.middleSymbol {
            versesText += "\(sym)\(verse.endVerse)"
        }
        self.verseRange = versesText
        self.content = verse.contents.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ".", with: "") + "\n"
        self.head = verse.head
        self.subhead = verse.subHead
    }
}
