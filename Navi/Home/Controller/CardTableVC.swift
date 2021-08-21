//
//  CardTableVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

import UIKit

class CardTableVC: ViewController {
    var heads: [Head] = [] {
        didSet {
            viewModel = CardTableViewModel(heads)
        }
    }
    
    var viewModel: CardTableViewModel? {
        didSet {
            updateView()
        }
    }
    
    var cardTV: CardTableView = {
        let tv = CardTableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func configureConstraints() {
        view.addSubview(cardTV)
        cardTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cardTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cardTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cardTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func updateView() {
        let viewModel = CardTableViewModel(heads)
        self.title = viewModel.title
        
        let res = DataBaseService.shared.fetch(request: Verse.fetchReqest(of: heads))
        cardTV.verses = res
    }
}
