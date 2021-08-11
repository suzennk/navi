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
    
    private let buttonHeight: CGFloat = 80
    private let padding: CGFloat = 20
    
    var isFolded: Bool = true {
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
        b.backgroundColor = unselectedColor
        b.layer.cornerRadius = buttonHeight / 2
        b.addTarget(self, action: #selector(handleFoldUnfold), for: .touchUpInside)
        return b
    }()
    
    private let unselectedColor: UIColor = .lightGray
    private let selectedColor: UIColor = .yellow
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    func updateView() {
        button.setTitle(theme, for: .normal)
        
//        if isSelected {
//            button.backgroundColor = foldedColor
//        } else {
//            button.backgroundColor = unfoldedColor
//        }
    }
    
    func configureConstraints() {
        addSubview(button)
        
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
    }
    
    @objc func handleFoldUnfold() {
        sendActions(for: .touchUpInside)
        isFolded = !isFolded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
