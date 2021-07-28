//
//  HomeVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class HomeVC: ViewController {

    let verseView: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "오늘날 내게 네게 명하는 이 말씀을 너는 마음에 새기고 (신6:6)"
        l.numberOfLines = 0
        return l
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Set navigation bar title as large title
        title = "오늘의 말씀"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    override func configureConstraints() {
        view.addSubview(verseView)
        verseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        verseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        verseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        verseView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
