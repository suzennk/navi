//
//  OYODetailVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/12.
//

import Foundation
import UIKit

class OYODetailVC: ViewController {
    
    let verseContentTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = .preferredFont(forTextStyle: .body)
        return tv
    }()
    
    let verseRangeLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .body)
        l.textColor = .systemGray
        l.textAlignment = .right
        return l
    }()
    
    var viewModel: OYODetailViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func configureConstraints() {
        let stackView = UIStackView(arrangedSubviews: [verseContentTextView, verseRangeLabel, UIView()])
        stackView.axis = .vertical
        stackView.alignment = .fill
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
    }
    
    func updateView() {
        guard let vm = viewModel else { return }
        title = vm.title
        verseRangeLabel.text = vm.verseRange
        verseContentTextView.text = vm.content
    }
}
