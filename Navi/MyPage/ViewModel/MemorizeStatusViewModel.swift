//
//  MemorizeStatusViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/13.
//

import Foundation

struct MemorizeStatusViewModel {
    let status: [(title: String, content: String)]
    let memorizeStatus: [(theme: String, memorized: Int, total: Int)]
    
    init() {
        let verses = DataBaseService.shared.fetch(request: Verse.fetchRequest())
        let memCount = verses.filter { $0.memorized == true }.count
        let oyoVerses = DataBaseService.shared.fetch(request: Verse.fetchRequestOfOYO())
        let oyoMemCount = oyoVerses.filter { $0.memorized == true }.count
        
        status = [
            ("외운 카드 수 / 모든 카드 수", "\(memCount) / \(verses.count)개 "),
            ("외운 카드 수 / OYO 카드 수", "\(oyoMemCount) / \(oyoVerses.count)개 ")
        ]
        
        var memStatus = [(theme: String, memorized: Int, total: Int)]()
        DataBaseService.shared.themes.forEach { theme in
            let verses = DataBaseService.shared.fetch(request: Verse.fetchRequest(of: theme))
            let total = verses.count
            let memorized = verses.filter{ $0.memorized }.count
            memStatus.append((theme, memorized, total))
        }
        memorizeStatus = memStatus
    }
}
