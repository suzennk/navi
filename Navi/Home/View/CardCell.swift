//
//  CardCell.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/21.
//

import UIKit
import Lottie

class CardCell: UITableViewCell {
    
    private let selectedImage = UIImage(systemName: "checkmark.square.fill")
    private let unselectedImage = UIImage(systemName: "square")
    
    var viewModel: CardViewModel? {
        didSet {
            updateView()
        }
    }
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .title3, weight: .bold)
        l.textColor = UIColor(named: "card-title")
        return l
    }()
    
    lazy var checkImageView: AnimationView = {
        let iv = AnimationView(animation: Animation.named("check-success-green"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        iv.tintColor = .naviYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let verseRangeLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        return l
    }()
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .body)
        l.numberOfLines = 0
        return l
    }()
    
    let headLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .body, weight: .light)
        return l
    }()
    
    let littleVerseRangeLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .body, weight: .light)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            checkImageView.play(completion: nil)
        } else {
            checkImageView.stop()
        }
    }
    
    func configureConstraints() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "card-bg")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8.0
        view.layer.shadowOffset = .init(width: 5, height: 5)
        view.layer.masksToBounds = false
        
        let titleSV = UIStackView(arrangedSubviews: [titleLabel, checkImageView])
        let bottomSV = UIStackView(arrangedSubviews: [headLabel, UIView(), littleVerseRangeLabel])
        
        let stackView = UIStackView(arrangedSubviews: [
        titleSV,
        verseRangeLabel,
        contentLabel,
        bottomSV])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true

        
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    func updateView() {
        if let vm = viewModel {
            titleLabel.text = vm.title
            verseRangeLabel.text = vm.verseRange
            contentLabel.text = vm.content
            headLabel.text = vm.head
            littleVerseRangeLabel.text = vm.verseRange
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let duration = highlighted ? 0.35 : 0.3
        let transform = highlighted ?
            CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
        let animations = {
            self.transform = transform
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: animations,
                       completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
