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
    
    init(_ verse: Verse) {
        title = verse.title
        var versesText = "\(verse.bible) \(verse.chapter):\(verse.startVerse)"
        if let sym = verse.middleSymbol {
            versesText += "\(sym)\(verse.endVerse)"
        }
        verseRange = versesText
        content = verse.contents
        head = verse.head
    }
}
