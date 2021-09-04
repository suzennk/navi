//
//  AddOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit
import PanModal

class AddNavigationController: UINavigationController, PanModalPresentable {
    private let addVC = AddOnYourOwnVC()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [addVC]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PanModalPresentable
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
}

private class AddOnYourOwnVC: ViewController {
    
    let contents = ["테마", "성경", "장(시작)", "절(시작)", "장(끝)", "절(끝)"]
    lazy var textFields = contents.map{ NaviInputTextField(name: $0) }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "OYO 추가하기"
        
        view.backgroundColor = .white
        
        setupNavigationBar()
    }
    
    override func configureConstraints() {
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneTapped))
    }
    
    @objc private func handleCancelTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - TODO: implementation incomplete
    @objc private func handleDoneTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - PanModalPresentable
extension AddOnYourOwnVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
}
