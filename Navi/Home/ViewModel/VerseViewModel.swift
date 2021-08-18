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
        var text = ""
//        text += "@@@@@@\(verse.id)@@@@@@ "
        text += "\(verse.contents) (\(verse.bible) \(verse.chapter):\(verse.startVerse)"
        if let sym = verse.middleSymbol {
            text += "\(sym)\(verse.endVerse)"
        }
        text += ")"
        
        self.text = text
    }
}

