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
    @IBOutlet weak var resetButton: RoundedBorderButton!
    @IBOutlet weak var confirmButton: RoundedBorderButton!
    
    let answerCVDelegate = AnswerCVDelegate()
    
    var quizType: QuizType? = nil
    var questionVerses: [Verse] = [] {
        didSet {
            scrambledFragments = questionVerses.map({ verse in
                verse.contents.components(separatedBy: " ").map { $0 }.shuffled()
            })
        }
    }
    
    var currentQuestionNumber = 0
    var scrambledFragments = [[String]]()
    var fragments = [String]()
    
    let timePerQuestion = 60.0
    var scheduledTimer: Timer? = nil
    var timer: Timer? = nil
    var deadline: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 답쪽 Collection View Leading 정렬
        answerCVDelegate.superViewController = self
        answerCollectionView.delegate = answerCVDelegate
        answerCollectionView.dataSource = answerCVDelegate
                
        let answerLayout = answerCollectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        answerLayout?.horizontalAlignment = .leading
        
        // 타이머 슬라이더 thumbImage 없애기
        timerSlider.setThumbImage(UIImage(), for: .normal)
        
        // 질문쪽 Collection View Leading 정렬
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
                
        let questionLayout = questionCollectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        questionLayout?.horizontalAlignment = .leading
        
        // 초기화, 확인 버튼
        resetButton.button.layer.cornerRadius = 20
        resetButton.button.setTitle("초기화", for: .normal)
        resetButton.button.addTarget(self, action: #selector(handleResetTapped), for: .touchUpInside)
        confirmButton.button.layer.cornerRadius = 20
        confirmButton.button.setTitle("확인", for: .normal)
        confirmButton.button.backgroundColor = .naviYellow
        confirmButton.button.addTarget(self, action: #selector(handleConfirmTapped), for: .touchUpInside)
        
        initializeQuiz()
        startRound()
    }
    
    @objc func startRound() {
        guard currentQuestionNumber < questionVerses.count else {
            print("finished!")
            self.dismiss(animated: true)
            return
        }
        questionNumberLabel.text = "질문 \(currentQuestionNumber + 1) / \(questionVerses.count)"

        answerCVDelegate.answer = []
        answerCollectionView.reloadData()
        
        fragments = scrambledFragments[currentQuestionNumber]
        questionCollectionView.reloadData()
        
        self.deadline = Date() + timePerQuestion
        
        self.scheduledTimer?.invalidate()
        self.scheduledTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleTimerFired), userInfo: nil, repeats: true)
        self.timer?.invalidate()
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
        answerCollectionView.isUserInteractionEnabled = false
        questionCollectionView.isUserInteractionEnabled = false

        animationView.animation = Animation.named("invalid")
        animationView.isHidden = false
        animationView.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animationView.isHidden = true
            self.currentQuestionNumber += 1
            self.startRound()
            self.answerCollectionView.isUserInteractionEnabled = true
            self.questionCollectionView.isUserInteractionEnabled = true
        }
    }
    
    @objc func handleResetTapped() {
        answerCVDelegate.answer = []
        answerCollectionView.reloadData()
        
        fragments = scrambledFragments[currentQuestionNumber]
        questionCollectionView.reloadData()
    }
    
    @objc func handleConfirmTapped() {
        // 사용하지 않은 조각이 있으면 리턴
        guard fragments.isEmpty else { return }
        
        answerCollectionView.isUserInteractionEnabled = false
        questionCollectionView.isUserInteractionEnabled = false

        // 답이 맞으면
        let answer = answerCVDelegate.answer
        let actualAnswer = questionVerses[currentQuestionNumber]
        let isCorrect = answer.joined() == actualAnswer.contents.replacingOccurrences(of: " ", with: "")
        if isCorrect {
            animationView.animation = Animation.named("correct")
        } else {
            animationView.animation = Animation.named("invalid")
        }
        
        animationView.isHidden = false
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animationView.isHidden = true
            if isCorrect {
                self.currentQuestionNumber += 1
                self.startRound()
            }
            self.answerCollectionView.isUserInteractionEnabled = true
            self.questionCollectionView.isUserInteractionEnabled = true
        }
    }
}

extension WordOrderingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fragments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fragmentCell", for: indexPath) as? FragmentCell else {
            return UICollectionViewCell()
        }
        
        cell.fragmentView.backgroundColor = .systemGray5
        cell.label.text = fragments[indexPath.item]
        cell.label.sizeToFit()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = fragments.remove(at: indexPath.item)
        answerCVDelegate.answer.append(selectedItem)
        
        answerCollectionView.reloadData()
        questionCollectionView.reloadData()
    }
}

class AnswerCVDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var answer = [String]()
    var superViewController: WordOrderingVC? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        answer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answerFragmentCell", for: indexPath) as? AnswerFragmentCell else {
            return UICollectionViewCell()
        }
        
        cell.fragmentView.backgroundColor = .naviYellow
        cell.label.text = answer[indexPath.item]
        cell.label.sizeToFit()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = answer.remove(at: indexPath.item)
        superViewController?.fragments.append(selectedItem)
        superViewController?.answerCollectionView.reloadData()
        superViewController?.questionCollectionView.reloadData()
    }
}
