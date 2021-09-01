//
//  CardTableViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

struct CardTableViewModel {
    let heads: [String]
    let title: String
    
    init(_ heads: [String]) {
        self.heads = heads
        
        var title = "암송하기"
        if heads.count == 1 {
            title = heads.first ?? title
        }
        self.title = title
    }
}
