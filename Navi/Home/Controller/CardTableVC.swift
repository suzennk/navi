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
    
    private var sortMethod: SortMethod = .original {
        didSet {
            updateView()
        }
    }
    
    private var cardTV: CardTableView = {
        let tv = CardTableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBarButtonItems()
    }
    
    func setupBarButtonItems() {
        // Set up actions for sorting verses
        let defaultAction       = UIAction(title: "기본순",
                                           image: UIImage(systemName: ""),
                                           handler: { _ in self.sortMethod = .original })
        let alphabeticalAction  = UIAction(title: "가나다순",
                                           image: UIImage(systemName: "abc"),
                                           handler: { _ in self.sortMethod = .alphabetical })
        let shuffleAction       = UIAction(title: "랜덤",
                                           image: UIImage(systemName: "shuffle"),
                                           handler: { _ in self.sortMethod = .shuffle })

        let menu = UIMenu(title: "정렬", image: nil, identifier: nil, options: .displayInline, children: [defaultAction, alphabeticalAction, shuffleAction])
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: nil)
        
        filterButton.menu = menu
        
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    override func configureConstraints() {
        view.addSubview(cardTV)
        cardTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cardTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cardTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cardTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func updateView() {
        guard let vm = viewModel else {
            debugPrint("No view model available")
            return
        }
        
        self.title = vm.title
        
        let res = DataBaseService.shared.fetch(request: Verse.fetchReqest(of: vm.heads))
        
        switch sortMethod {
        case .alphabetical:
            cardTV.verses = res.sorted(by: { $0.bible < $1.bible })
        case .shuffle:
            cardTV.verses = res.shuffled()
        default:
            cardTV.verses = res
        }
    }
}
