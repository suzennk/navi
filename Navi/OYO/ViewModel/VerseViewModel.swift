//
//  VerseViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import Foundation

// curently used in oyo table view cell only
struct VerseViewModel {
    let content: String
    let rangeText: String
    let text: String
    
    init(_ verse: Verse) {
        var rangeText = "\(verse.bible) \(verse.chapter):\(verse.startVerse)"
        if let sym = verse.middleSymbol, sym.isEmpty == false {
            if ["상", "하"].contains(sym) {
                rangeText += " \(sym)"
            } else {
                rangeText += "\(sym)"
                rangeText += "\(verse.endVerse)"
            }
        }
        
        var text = ""
        text += "\(verse.contents)"
        self.content = text
        
        text += "(\(rangeText))"
        
        self.rangeText = rangeText
        self.text = text
    }
}

