//
//  CardTableView.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

import UIKit
import CoreData

class CardTableView: UITableView {
   
    private let cellId = "cardCellId"
    
    var verses: [Verse] = [] {
        didSet {
            filteredVerses = verses
        }
    }
    
    var filteredVerses: [Verse] = [] {
        didSet {
            // Update UI for memorized verses
            filteredVerses.enumerated().filter {
                $0.element.memorized == true
            }.forEach { (idx, _) in
                let indexPath = IndexPath(row: idx, section: 0)
                selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    var sortMethod: SortMethod = .original {
        didSet {
            if oldValue == sortMethod { return }
            switch sortMethod {
            case .alphabetical:
                filteredVerses = verses.sorted(by: { $0.bible < $1.bible })
            case .shuffle:
                filteredVerses = verses.shuffled()
            default:
                filteredVerses = verses
            }
        }
    }
    
    var hidesVerseRange: Bool = false {
        didSet {
            reloadData()
        }
    }
    var hidesContent: Bool = false {
        didSet {
            reloadData()
        }
    }
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let verse = filteredVerses[indexPath.row]
        verse.setValue(true, forKey: "memorized")
        DataBaseService.shared.save()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let verse = filteredVerses[indexPath.row]
        verse.setValue(false, forKey: "memorized")
        DataBaseService.shared.save()
    }
}

extension CardTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVerses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CardCell else { return UITableViewCell() }
        
        let verse = filteredVerses[indexPath.row]
        cell.viewModel = CardViewModel(verse)
        
        cell.contentLabel.alpha = hidesContent ? 0 : 1
        cell.verseRangeLabel.alpha = hidesVerseRange ? 0 : 1
        
        return cell
    }
    
}