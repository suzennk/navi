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
    @IBOutlet weak var startButton: BaseButton!
    
    @IBOutlet weak var enabledConstraint: NSLayoutConstraint!
    @IBOutlet weak var disabledConstraint: NSLayoutConstraint!
    
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
        
        startButton.onSelected = handleStartTapped
        startButton.button.setTitle("지금 시작하기", for: .normal)
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        .init(width: 0, height: 80)
    }
    
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
        updateUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateUI()
    }
    
    func updateUI() {
        let selectedIndexPaths = collectionView.indexPathsForSelectedItems ?? []
        if !selectedIndexPaths.isEmpty {
            enabledConstraint.isActive = true
            disabledConstraint.isActive = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            enabledConstraint.isActive = false
            disabledConstraint.isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func handleStartTapped() {
        if quizType == .bibleRange || quizType == .title {
            performSegue(withIdentifier: "startQuizSegue", sender: self)
        } else if quizType == .content {
            performSegue(withIdentifier: "wordOrderingSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let multipleChoiceVC = segue.destination as? MultipleChoiceVC {
            let selectedIndexPaths = collectionView.indexPathsForSelectedItems ?? []
            let selectedCategories = selectedIndexPaths.compactMap { indexPath in
                categories[indexPath.item]
            }
            let candidateVerses = DataBaseService.shared.fetchVerse(of: selectedCategories)
            multipleChoiceVC.quizType = self.quizType
            multipleChoiceVC.questionVerses = (1...10).compactMap { _ in candidateVerses.randomElement()
            }
        } else if let wordOrderingVC = segue.destination as? WordOrderingVC {
            let selectedIndexPaths = collectionView.indexPathsForSelectedItems ?? []
            let selectedCategories = selectedIndexPaths.compactMap { indexPath in
                categories[indexPath.item]
            }
            let candidateVerses = DataBaseService.shared.fetchVerse(of: selectedCategories)
            wordOrderingVC.quizType = self.quizType
            wordOrderingVC.questionVerses = (1...10).compactMap { _ in candidateVerses.randomElement() }
        }
    }
}

extension QuizRangeCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 150)
    }
}
