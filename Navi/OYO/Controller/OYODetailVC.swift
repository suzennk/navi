//
//  OYODetailVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/12.
//

import Foundation
import UIKit

class OYODetailVC: ViewController {
    private let verseContentTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = .preferredFont(forTextStyle: .body)
        return tv
    }()
    
    private let verseRangeLabel: UILabel = {
        let l = UILabel()
        l.font = .preferredFont(forTextStyle: .body)
        l.textColor = .systemGray
        l.textAlignment = .right
        return l
    }()
    
    var verse: Verse? {
        didSet {
            guard let verse = verse else { return }
            viewModel = OYODetailViewModel(verse: verse)
        }
    }
    
    private var viewModel: OYODetailViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupBarButtonItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
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
    
    func setupBarButtonItems() {
        let editItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(handleEditButtonTapped))
        let deleteItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(handleDeleteButtonTapped))
        navigationItem.rightBarButtonItems = [deleteItem, editItem]
    }
    
    func updateView() {
        guard let vm = viewModel else { return }
        title = vm.title
        verseRangeLabel.text = vm.verseRange
        verseContentTextView.text = vm.content
    }
    
    @objc func handleEditButtonTapped() {
        let editOyoVC = EditOnYourOwnVC()
        editOyoVC.originalVerse = verse
        editOyoVC.delegate = self
        editOyoVC.modalPresentationStyle = .fullScreen
        self.present(editOyoVC, animated: true, completion: nil)
    }
    
    @objc func handleDeleteButtonTapped() {
        guard let verse = verse else {
            debugPrint(type(of: self), "verse is nil")
            return
        }
        
        self.alert(title: "삭제하시겠습니까?", message: nil, okTitle: "취소", okHandler: { _ in 
            // 아무것도 안함
        }, cancelTitle: "삭제", cancelHandler: { [weak self] _ in
            switch DataBaseService.shared.remove(verse) {
            default:
                self?.navigationController?.popViewController(animated: true)
            }
        }, completion: nil)
    }
}
