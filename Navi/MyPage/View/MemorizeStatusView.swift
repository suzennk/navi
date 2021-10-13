//
//  MemorizeStatusView.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/13.
//

import UIKit

class MemorizeStatusView: UIView {
    var viewModel = MemorizeStatusViewModel() {
        didSet {
            updateView()
        }
    }
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.layer.cornerRadius = 12
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .naviYellow
        
        layer.cornerRadius = 20
        
        configureConstraints()
        updateView()
    }
    
    func updateView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let vm = viewModel
        vm.statuses.map { (title, content) in
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 18)
            titleLabel.textColor = .tertiarySystemBackground
            titleLabel.sizeToFit()
            
            let contentLabel = UILabel()
            contentLabel.text = content
            contentLabel.font = .systemFont(ofSize: 30, weight: .light)
            contentLabel.textAlignment = .right
            let spacer = UIView()
            spacer.snp.makeConstraints { make in
                make.width.equalTo(8)
            }
            let contentStackView = UIStackView(arrangedSubviews: [contentLabel, spacer])
            contentStackView.axis = .horizontal
            contentStackView.backgroundColor = .tertiarySystemBackground
            contentStackView.clipsToBounds = true
            contentStackView.layer.cornerRadius = 10
            contentStackView.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
            
            let stackView = UIStackView(arrangedSubviews: [titleLabel, contentStackView])
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing
            stackView.spacing = 4
            
            return stackView
        }.forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func configureConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges).inset(UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
