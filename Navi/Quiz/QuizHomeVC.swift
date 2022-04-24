//
//  QuizVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class QuizHomeVC: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let quizeRangeVC = segue.destination as? QuizRangeCollectionVC else { return }
        if segue.identifier == "bibleRangeSegue" {
            quizeRangeVC.quizType = .bibleRange
        } else if segue.identifier == "titleSegue" {
            quizeRangeVC.quizType = .title
        } else if segue.identifier == "contentSegue" {
            quizeRangeVC.quizType = .content
        }
    }
}
