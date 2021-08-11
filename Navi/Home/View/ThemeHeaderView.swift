//
//  ThemeHeaderView.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import UIKit

/**
    This Header View allows section header to act as a button to fold/unfold a section
 */
class ThemeHeaderView: UIControl {
    
    private let buttonHeight: CGFloat = 72
    private let buttonWidth: CGFloat = 330
    private let padding: CGFloat = 20
    
    var isFolded: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateView()
        }
    }
    
    var theme: String = "테마 이름" {
        didSet {
            updateView()
        }
    }
    
    /**
        This button fold/unfolds a section
     */
    lazy var button: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .unselectedBackground
        b.layer.cornerRadius = buttonHeight / 2
        b.addTarget(self, action: #selector(handleFoldUnfold), for: .touchUpInside)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    func updateView() {
        print("update view")
        
        button.setTitle(theme, for: .normal)
        
        if isSelected {
            button.setTitleColor(.selectedText, for: .normal)
            button.backgroundColor = .selectedBackground
        } else {
            button.setTitleColor(.unselectedText, for: .normal)
            button.backgroundColor = .unselectedBackground
        }
    }
    
    func configureConstraints() {
        addSubview(button)
        
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc func handleFoldUnfold() {
        sendActions(for: .touchUpInside)
        isFolded = !isFolded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
