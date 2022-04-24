//
//  MultipleChoiceVC.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/23.
//

import UIKit
import Lottie

class MultipleChoiceVC: ViewController {
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var button0: RoundedBorderButton!
    @IBOutlet weak var button1: RoundedBorderButton!
    @IBOutlet weak var button2: RoundedBorderButton!
    @IBOutlet weak var button3: RoundedBorderButton!
    
    var answerButtons: [RoundedBorderButton] {
        get {
            return [button0, button1, button2, button3].compactMap { $0 }
        }
    }
    
    var quizType: QuizType? = nil
    var questionVerses: [Verse] = []
    
    var currentQuestionNumber = 0
    var actualAnswer = 0
    var selectedAnswer = 0
    
    let timePerQuestion = 10.0
    var scheduledTimer: Timer? = nil
    var timer: Timer? = nil
    var deadline: Date = Date()
    
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
        answerButtons.forEach {
            $0.button.backgroundColor = .systemGray5
            $0.button.layer.borderWidth = 0
        }
        
        let viewModel = CardViewModel(questionVerses[currentQuestionNumber])
        
        if quizType == .bibleRange {
            questionTextView.text = viewModel.content
        } else if quizType == .title {
            questionTextView.text = "\(viewModel.content)[\(viewModel.verseRange)]"
        }
        
       answerButtons.forEach { button in
            if let verse = DataBaseService.shared.verses.randomElement() {
                let cardVM = CardViewModel(verse)
                if quizType == .bibleRange {
                    button.button.setTitle(cardVM.verseRange, for: .normal)
                } else {
                    button.button.setTitle(cardVM.title, for: .normal)
                }
            } else {
                if quizType == .title {
                    button.button.setTitle("창세기 1:1", for: .normal)
                } else {
                    button.button.setTitle("1. 구원의 확신", for: .normal)
                }
            }
        }
        
        let actualAnswer = (0...3).randomElement() ?? 0
        self.actualAnswer = actualAnswer
        if quizType == .bibleRange {
            answerButtons[actualAnswer].button.setTitle(viewModel.verseRange, for: .normal)
        } else if quizType == .title {
            answerButtons[actualAnswer].button.setTitle(viewModel.title, for: .normal)
        }
        
        self.deadline = Date() + timePerQuestion
        self.scheduledTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleTimerFired), userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(timeInterval: timePerQuestion, target: self, selector: #selector(handleTimesUp), userInfo: nil, repeats: false)
    }
    
    func initializeQuiz() {
        if let quizType = quizType {
            quizTypeLabel.text = quizType.rawValue
        }
        currentQuestionNumber = 0
        timerSlider.minimumValue = 0
        timerSlider.maximumValue = 1
    }
    
    @IBAction func handleXTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func handleAnswerTapped(_ sender: Any) {
        self.scheduledTimer?.invalidate()
        self.timer?.invalidate()
        
        if let button = sender as? UIButton {
            if button.tag == self.actualAnswer {
                // selected correct answer
                animationView.animation = Animation.named("correct")
                answerButtons[button.tag].button.layer.borderWidth = 2
                answerButtons[button.tag].button.layer.borderColor = UIColor.systemGreen.cgColor
                answerButtons[button.tag].button.backgroundColor = .systemBackground
            } else {
                // selected incorrect answer
                animationView.animation = Animation.named("invalid")
                answerButtons[button.tag].button.layer.borderWidth = 2
                answerButtons[button.tag].button.layer.borderColor = UIColor.systemRed.cgColor
                answerButtons[button.tag].button.backgroundColor = .systemBackground
                
                answerButtons[actualAnswer].button.layer.borderWidth = 2
                answerButtons[actualAnswer].button.layer.borderColor = UIColor.systemGreen.cgColor
                answerButtons[actualAnswer].button.backgroundColor = .systemBackground
            }
        } else {
            animationView.animation = Animation.named("invalid")
            answerButtons[actualAnswer].button.layer.borderWidth = 2
            answerButtons[actualAnswer].button.layer.borderColor = UIColor.orange.cgColor
            answerButtons[actualAnswer].button.backgroundColor = .systemBackground
        }
        
        animationView.isHidden = false
        answerButtons.forEach {
            $0.button.isUserInteractionEnabled = false
        }
        
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animationView.isHidden = true
            self.currentQuestionNumber += 1
            self.startRound()
            [self.button0, self.button1, self.button2, self.button3].forEach {
                $0?.button.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func handleTimerFired() {
        timerSlider.value = Float(Date().distance(to: self.deadline) / timePerQuestion)
    }
    
    @objc func handleTimesUp() {
        handleAnswerTapped(0)
    }
}
