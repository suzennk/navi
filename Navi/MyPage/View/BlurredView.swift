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
    
    var contentView: UIView {
        get {
            return self.vibrancyView.contentView
        }
    }
    
    lazy var vibrancyView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemUltraThinMaterial))
        let vv = UIVisualEffectView(effect: vibrancyEffect)
        return vv
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let bv = UIVisualEffectView(effect: blurEffect)
        bv.clipsToBounds = true
        bv.layer.borderWidth = 0.5
        bv.layer.borderColor = UIColor.systemBackground.cgColor
        bv.layer.cornerRadius = cornerRadius
        return bv
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
        addSubview(blurView)
        
        
        blurView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges).inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.snp.makeConstraints { make in
            make.edges.equalTo(blurView.snp.edges)
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(blurView.snp.edges)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
