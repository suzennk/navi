//
//  HomeVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

class HomeVC: ViewController, UITableViewDelegate {

    lazy var verseGroupTV: VerseGroupTableView = {
        let tv = VerseGroupTableView(frame: view.frame)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var selectionButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("암송하러가기", for: .normal)
        b.setTitleColor(.darkText, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        b.backgroundColor = .naviYellow
        
        b.layer.cornerRadius = 20
        b.layer.shadowOpacity = 0.3
        b.layer.shadowOffset = .init(width: 5, height: 5)
        b.layer.shadowRadius = 10
        b.layer.masksToBounds = false
        
        b.addTarget(self, action: #selector(handleMemorizeButtonTapped), for: .touchUpInside)
        return b
    }()
    
    private var disabledTVContraints: NSLayoutConstraint?
    private var enabledTVContraints: NSLayoutConstraint?
    private var enabledConstraint: NSLayoutConstraint?
    private var disabledConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        // Set navigation bar title as large title
        title = "오늘의 말씀"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        
        // set delegate
        verseGroupTV.homeDelegate = self
    }
    
    override func configureConstraints() {
        view.addSubview(verseGroupTV)
        view.addSubview(selectionButton)

        verseGroupTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        verseGroupTV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        verseGroupTV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        disabledTVContraints = verseGroupTV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        enabledTVContraints = verseGroupTV.bottomAnchor.constraint(equalTo: selectionButton.topAnchor)
        
        disabledTVContraints?.isActive = true
        enabledTVContraints?.isActive = false
        
        selectionButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        selectionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        selectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        enabledConstraint = selectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        disabledConstraint = selectionButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 16)
        
        disabledConstraint?.isActive = true
        enabledConstraint?.isActive = false
    }
    
    func updateView() {
        let selectedHeads = verseGroupTV.selectedHeads
        
        if selectedHeads.isEmpty {
            self.enabledTVContraints?.isActive = false
            self.disabledTVContraints?.isActive = true
            self.enabledConstraint?.isActive = false
            self.disabledConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.disabledTVContraints?.isActive = false
            self.enabledTVContraints?.isActive = true
            self.disabledConstraint?.isActive = false
            self.enabledConstraint?.isActive = true

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleMemorizeButtonTapped() {
        let categories = verseGroupTV.selectedHeads
        let cardVC = CardTableVC()
        cardVC.viewModel = CardTableViewModel(categories)
        navigationController?.pushViewController(cardVC, animated: true)
    }
}
