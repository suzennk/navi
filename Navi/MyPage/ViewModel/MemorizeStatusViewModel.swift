//
//  MemorizeStatusViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/13.
//

import Foundation

struct MemorizeStatusViewModel {
    let memorizeStatus: [(theme: String, memorizedPercentage: Double, totalPercentage: Double)]
    
    init() {
        var memStatus = [(theme: String, memorizedPercentage: Double, totalPercentage: Double)]()
        let max = DataBaseService.shared.themes.map { theme in
            DataBaseService.shared.fetch(request: Verse.fetchRequest(of: theme)).count
        }.max() ?? 0
        
        DataBaseService.shared.themes.forEach { theme in
            let verses = DataBaseService.shared.fetch(request: Verse.fetchRequest(of: theme))
            let total = verses.count
            let memorized = verses.filter{ $0.memorized }.count
            
            let totalPercentage: Double = total > 0 ? (Double(total) / Double(max)) * 0.75 + 0.25 : 0
            let memorizedPercentage: Double = total > 0 ? Double(memorized) / Double(total) : 0
            memStatus.append((theme, memorizedPercentage, totalPercentage))
        }
        memorizeStatus = memStatus
    }
}
