//
//  WordOrderingVC.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/24.
//

import UIKit
import Lottie

class WordOrderingVC: UIViewController {
    @IBOutlet weak var quizTypeLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var answerCollectionView: UICollectionView!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var questionCollectionView: UICollectionView!
    
    let qDelegate = QCollectionViewDelegate()
    
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
        
        questionCollectionView.delegate = qDelegate
        questionCollectionView.dataSource = qDelegate
        
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
    
    @objc func handleTimerFired() {
        timerSlider.value = Float(Date().distance(to: self.deadline) / timePerQuestion)
    }
    
    @objc func handleTimesUp() {

    }
}

class QCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fragmentCell", for: indexPath) as? FragmentCell else {
            return UICollectionViewCell()
        }
        
        cell.fragmentView.backgroundColor = .systemRed
        cell.label.text = String((1...((1...10).randomElement() ?? 5)).map({ _ in "A" }))
        cell.label.sizeToFit()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 44)
    }
}
