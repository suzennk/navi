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
    let bottomRight: String
    let bottomLeft: String
    
    init(_ verse: Verse) {
        self.title = verse.title.isEmpty ? verse.theme : verse.title
        
        if verse.theme == "OYO" {
            self.bottomLeft = verse.head
            self.bottomRight = "OYO"
            
        } else {
            self.bottomLeft = verse.subHead
            self.bottomRight = verse.head
        }
        
        var versesText = "\(verse.bible) \(verse.chapter):\(verse.startVerse)"
        if let sym = verse.middleSymbol, sym.isEmpty == false {
            if ["상", "하"].contains(sym) {
                versesText += " \(sym)"
            } else {
                versesText += "\(sym)"
                versesText += "\(verse.endVerse)"
            }
        }
        
        self.verseRange = versesText
        self.content = verse.contents.trimmingCharacters(in: .whitespaces) + "\n"
    }
}
