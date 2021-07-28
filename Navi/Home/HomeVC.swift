//
//  HomeVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class HomeVC: ViewController, UICollectionViewDelegate {

    let verseView: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "오늘날 내게 네게 명하는 이 말씀을 너는 마음에 새기고 (신6:6)"
        l.numberOfLines = 2
        return l
    }()

    lazy var verseGroupTV: UITableView = {
        let tv = VerseGroupTableView(frame: view.frame)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Set navigation bar title as large title
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        print("ViewDidLoad")
    }

    override func configureConstraints() {
//        view.addSubview(verseView)
//        verseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
//        verseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        verseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        verseView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(verseGroupTV)
        verseGroupTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        verseGroupTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        verseGroupTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        verseGroupTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        verseGroupTV.tableHeaderView = verseView
        verseView.widthAnchor.constraint(equalTo: verseGroupTV.widthAnchor).isActive = true
        verseView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at: \(indexPath)")
    }
}
