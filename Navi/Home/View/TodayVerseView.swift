//
//  TodayVerseView.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import UIKit

class TodayVerseView: UIView {
    
    private let padding: CGFloat = 16
    
    var verseViewModel: VerseViewModel? {
        didSet {
            updateView()
        }
    }
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 20, weight: .regular)
        l.numberOfLines = 0
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureConstraints()
    }
    
    func configureConstraints() {
        let stackView = UIStackView(arrangedSubviews: [contentLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

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
        contentLabel.text = verseViewModel?.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
