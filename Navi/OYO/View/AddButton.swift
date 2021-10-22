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

        setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.naviYellow, renderingMode: .alwaysTemplate), for: .normal)
        
        // disable highlighting on touch
        adjustsImageWhenHighlighted = false
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 70
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 5, height: 5)
        
        addTargets()
    }
    
    func addTargets() {
        addTarget(self, action: #selector(pressed), for: .touchDown)
    }
    
    @objc func pressed() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseOut]) {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseIn]) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
