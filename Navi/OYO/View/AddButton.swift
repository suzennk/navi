//
//  AddButton.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/22.
//

import UIKit

class AddButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .naviYellow
        if let plusImage = UIImage(systemName: "plus")?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal) {
            imageView?.snp.removeConstraints()
            imageView?.snp.makeConstraints { make in
                make.edges.equalTo(snp.edges).inset(16)
            }
            setImage(plusImage, for: .normal)
        }
        
        // disable highlighting on touch
        adjustsImageWhenHighlighted = false
        
        layer.cornerRadius = 30
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 5, height: 5)
        
        addTargets()
    }
    
    func addTargets() {
        addTarget(self, action: #selector(pressed), for: .touchDown)
        addTarget(self, action: #selector(cancelled), for: .touchUpOutside)
        addTarget(self, action: #selector(cancelled), for: .touchUpInside)
    }
    
    @objc func pressed() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseOut]) {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @objc func cancelled() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseIn]) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
