//
//  MultipleChoiceVC.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/23.
//

import UIKit

class MultipleChoiceVC: ViewController {
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var timerSlider: UISlider!
    
    @IBOutlet weak var button0: RoundedBorderButton!
    @IBOutlet weak var button1: RoundedBorderButton!
    @IBOutlet weak var button2: RoundedBorderButton!
    @IBOutlet weak var button3: RoundedBorderButton!
    
    var quizType: QuizType? = nil
    var questionVerses: [Verse] = []
    
    var currentQuestionNumber = 0
    var actualAnswer = 0
    var selectedAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 타이머 슬라이더 thumbImage 없애기
        timerSlider.setThumbImage(UIImage(), for: .normal)
        
        // 각 버튼에 태그 설정하고 action 달기
        [button0, button1, button2, button3].enumerated().forEach { index, view in
            view?.button.tag = index
            view?.button.addTarget(self, action: #selector(handleAnswerTapped(_:)), for: .touchUpInside)
        }
        
        initializeQuiz()
        startRound()
    }
    
    func startRound() {
        guard currentQuestionNumber < questionVerses.count else {
            print("finished!")
            self.dismiss(animated: true)
            return
        }
        questionNumberLabel.text = "질문 \(currentQuestionNumber + 1) / \(questionVerses.count)"

        let viewModel = CardViewModel(questionVerses[currentQuestionNumber])
        questionTextView.text = viewModel.content
        
        [button0, button1, button2, button3].forEach { button in
            if let verse = DataBaseService.shared.verses.randomElement() {
                let cardVM = CardViewModel(verse)
                button?.button.setTitle(cardVM.verseRange, for: .normal)
            } else {
                button?.button.setTitle("창세기 1:1", for: .normal)
            }
        }
        
        let actualAnswer = (0...3).randomElement() ?? 0
        self.actualAnswer = actualAnswer
        [button0, button1, button2, button3][actualAnswer]?
            .button.setTitle(viewModel.verseRange, for: .normal)
    }
    
    func initializeQuiz() {
        if let quizType = quizType {
            quizTypeLabel.text = quizType.rawValue
        }
        currentQuestionNumber = 0
    }
    
    @IBAction func handleXTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func handleAnswerTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.tag == self.actualAnswer {
                print("correct!")
            } else {
                print("incorrect!")
            }
            
            currentQuestionNumber += 1
            startRound()
        }
    }
}
