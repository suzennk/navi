//
//  MemorizeStatusViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/13.
//

import Foundation

struct MemorizeStatusViewModel {
    let statuses: [(title: String, content: String)]
    
    init() {
        let verses = DataBaseService.shared.fetch(request: Verse.fetchRequest())
        let memCount = verses.filter { $0.memorized == true }.count
        let oyoVerses = DataBaseService.shared.fetch(request: Verse.fetchRequestOfOYO())
        let oyoMemCount = oyoVerses.filter { $0.memorized == true }.count
        
        statuses = [
            ("외운 카드 수 / 총 카드 수", "\(memCount) / \(verses.count)개 "),
            ("외운 카드 수 / 총 OYO 수", "\(oyoMemCount) / \(oyoVerses.count)개 ")
        ]
    }
}
