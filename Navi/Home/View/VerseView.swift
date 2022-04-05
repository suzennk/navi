//
//  VerseView.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import UIKit

class VerseView: UIView {
    
    private let padding: CGFloat = 16
    
    var viewModel: OYOCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .body)
        l.lineBreakMode = .byCharWrapping
        l.numberOfLines = 0
        return l
    }()
    
    let rangeLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .callout)
        l.textColor = .systemGray
        l.textAlignment = .right
        l.numberOfLines = 1
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureConstraints()
    }
    
    func configureConstraints() {
        let stackView = UIStackView(arrangedSubviews: [contentLabel, rangeLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(100)
            make.edges.equalTo(self.snp.edges).inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        }
    }
    
    func updateView() {
        contentLabel.text = viewModel?.content
        rangeLabel.text = viewModel?.rangeText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
