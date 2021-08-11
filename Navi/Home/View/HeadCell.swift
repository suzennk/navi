//
//  HeadCell.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/11.
//

import UIKit

class HeadCell: UITableViewCell {
    
    private let height: CGFloat = 24
    private let width: CGFloat = 330
    private let padding: CGFloat = 16
    
    private let selectedImage = UIImage(systemName: "checkmark.square")
    private let unselectedImage = UIImage(systemName: "square")
    
    let checkBox: UIImageView = {
       let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tintColor = .unselectedBackground
        v.image = UIImage(systemName: "square")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    var head: String = "테마 헤드" {
        didSet {
            updateView()
        }
    }
    
    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = head
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureConstraints()
    }
    
    func configureConstraints() {
        let stackView = UIStackView(arrangedSubviews: [checkBox, headLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
            checkBox.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            checkBox.widthAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: height),
            stackView.widthAnchor.constraint(equalToConstant: width - 2*padding)
        ])
    }
    
    func updateView() {
        headLabel.text = head
        
        if isSelected {
            checkBox.tintColor = .selectedBackground
            checkBox.image = selectedImage
        } else {
            checkBox.tintColor = .unselectedBackground
            checkBox.image = unselectedImage
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
