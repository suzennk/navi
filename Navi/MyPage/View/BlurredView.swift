//
//  BlurredView.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/13.
//

import UIKit
import SnapKit

class BlurredView: UIView {
    let cornerRadius: CGFloat = 20
    
    lazy var view: UIView = {
        let blurEffect = UIBlurEffect(style: .prominent)
        let v = UIVisualEffectView(effect: blurEffect)
        v.clipsToBounds = true
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.systemBackground.cgColor
        v.layer.cornerRadius = cornerRadius
        return v
    }()
    
    lazy var shadowView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = cornerRadius
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowRadius = 8.0
        v.layer.shadowOffset = .init(width: 0, height: 5)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(shadowView)
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges).inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }

        alpha = 0.6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}