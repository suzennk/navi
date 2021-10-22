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
        
        layer.cornerRadius = 40

        setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(.naviYellow, renderingMode: .alwaysTemplate), for: .normal)
        configureConstraints()
    }
    
    func configureConstraints() {
        snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
