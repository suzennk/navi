//
//  VerseView.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import UIKit

class VerseView: UIView {
    
    private let padding: CGFloat = 16
    
    var viewModel: VerseViewModel? {
        didSet {
            updateView()
        }
    }
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .preferredFont(forTextStyle: .body)
        l.numberOfLines = 0
        return l
    }()
    
    let rangeLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .callout)
        l.textColor = .systemGray
        l.numberOfLines = 1
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureConstraints()
    }
    
    func configureConstraints() {
        let stackView = UIStackView(arrangedSubviews: [contentLabel, rangeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing

        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
    
    func updateView() {
        contentLabel.text = viewModel?.content
        rangeLabel.text = viewModel?.rangeText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
