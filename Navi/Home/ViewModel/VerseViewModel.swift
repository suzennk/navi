//
//  VerseViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import Foundation

struct VerseViewModel {
    let text: String
    
    init(_ verse: Verse) {
        text = "\(verse.contents) (\(verse.bible) \(verse.chapter):\(verse.startVerse)\(verse.middleSymbol)\(verse.endVerse))"
    }
}

