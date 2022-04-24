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
    
    let answerCVDelegate = AnswerCVDelegate()
    
    var quizType: QuizType? = nil
    var questionVerses: [Verse] = []
    
    var currentQuestionNumber = 0
    var fragments = ["aa", "aaa", "aaaa", "aaaaa", "aaaaaa", "aaaaaaa", "aaaaaaaa"]
    
    let timePerQuestion = 10.0
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
