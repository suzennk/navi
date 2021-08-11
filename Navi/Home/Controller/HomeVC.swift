//
//  HomeVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class HomeVC: ViewController, UITableViewDelegate {

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
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
    }
    
    override func configureConstraints() {
        view.addSubview(verseGroupTV)
        verseGroupTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        verseGroupTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        verseGroupTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        verseGroupTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
}
