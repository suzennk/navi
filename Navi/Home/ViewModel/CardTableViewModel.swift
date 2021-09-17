//
//  CardTableViewModel.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

struct CardTableViewModel {
    let categories: [(Theme, Head)]
    let title: String
    
    init(_ categories: [(Theme, Head)]) {
        self.categories = categories
        
        var title = "암송하기"
        if categories.count == 1 {
            title = categories.first?.1 ?? title
        }
        self.title = title
    }
}
