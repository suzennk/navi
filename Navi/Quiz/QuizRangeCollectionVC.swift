//
//  QuizRangeCollectionVC.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/22.
//

import UIKit

private let reuseIdentifier = "circleCell"

class QuizRangeCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let categories: [(Theme, Head)] = {
        let themes = DataBaseService.shared.themes
        return themes.flatMap { theme in
            DataBaseService.shared.categories[theme]?.compactMap { (theme, $0) } ?? []
        }
    }()
    
    var quizType: QuizType = .bibleRange
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.allowsMultipleSelection = true
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CircleCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        let verses = DataBaseService.shared.fetchVerse(of: [category])
        cell.headLabel.text = category.0
        cell.subheadLabel.text = "\(category.1) (\(verses.count))"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
           selectedIndexPaths.isEmpty {
            
        } else {
            
        }
    }
}

extension QuizRangeCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 150)
    }
}
