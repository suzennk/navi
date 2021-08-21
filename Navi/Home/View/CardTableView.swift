//
//  CardTableView.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

import UIKit

class CardTableView: UITableView {
   
    private let cellId = "cardCellId"
    
    var verses: [Verse] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        
        separatorStyle = .none
        
        allowsMultipleSelection = true
        
        register(CardCell.self, forCellReuseIdentifier: cellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardTableView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        250
//    }
}

extension CardTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CardCell else { return UITableViewCell() }
        
        let verse = verses[indexPath.row]
        cell.viewModel = CardViewModel(verse)
        
        return cell
    }
    
}
