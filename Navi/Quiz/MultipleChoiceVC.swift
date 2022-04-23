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
    
    let questionVerses: [Verse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 타이머 슬라이더 thumbImage 없애기
        timerSlider.setThumbImage(UIImage(), for: .normal)
        
        // 각 버튼에 태그 설정하고 action 달기
        [button0, button1, button2, button3].enumerated().forEach { index, view in
            view?.button.tag = index
            view?.button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    @IBAction func handleXTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func handleButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            print(button.tag)
        }
    }
}
