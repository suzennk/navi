//
//  AddOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit
import PanModal
import SkyFloatingLabelTextField

enum VerseContents: String, CaseIterable, RawRepresentable {
    case theme = "테마"
    case bible = "성경"
    case startChapter = "장(시작)"
    case startVerse = "절(시작)"
    case endChapter = "장(끝)"
    case endVerse = "절(끝)"
    case content = "내용"

    var textField: SkyFloatingLabelTextField {
        let tf = SkyFloatingLabelTextField()
        tf.title = self.rawValue
        tf.placeholder = self.rawValue
        tf.disabledColor = .systemGray6
        tf.selectedLineColor = .naviYellow
        tf.selectedTitleColor = .naviYellow
//        switch self {
//        case .startChapter:
//            fallthrough
//        case .startVerse:
//            fallthrough
//        case .endChapter:
//            fallthrough
//        case .endVerse:
//            tf.keyboardType = .numberPad
//        case .theme:
//            fallthrough
//        case .bible:
//            tf.inputView = UIPickerView()
//        case .content: break
//        }
        return tf
    }
}

class AddOnYourOwnVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellId = "cellId"
    
    let cases = VerseContents.allCases
    lazy var textFields: [SkyFloatingLabelTextField] = VerseContents.allCases.map {
        let tf = $0.textField
        tf.delegate = self
        return tf
    }
    
    lazy var cancelButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.setTitleColor(.naviYellow, for: .normal)
        b.addTarget(self, action: #selector(handleCancelTapped), for: .touchUpInside)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 22
        b.snp.makeConstraints { make in
            make.width.equalTo(b.snp.height)
        }
        return b
    }()
    
    lazy var doneButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "checkmark"), for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 18)
        b.addTarget(self, action: #selector(handleDoneTapped), for: .touchUpInside)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 22
        b.snp.makeConstraints { make in
            make.width.equalTo(b.snp.height)
        }
        return b
    }()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupTableView()
    }
    
     override func configureConstraints() {
        let titleLabel = UILabel()
        titleLabel.text = "On Your Own"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, titleLabel, doneButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill

        view.addSubview(tableView)
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc private func handleCancelTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let tf = textFields[indexPath.row]
        cell.addSubview(tf)
        tf.snp.makeConstraints { make in
            make.edges.equalTo(cell.snp.edges).inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        return cell
    }
    
    // MARK: - TODO: implementation incomplete
    @objc private func handleDoneTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - PanModalPresentable
extension AddOnYourOwnVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return tableView
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
}

// MARK: - UITextFieldDelegate
extension AddOnYourOwnVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("\((textField as? SkyFloatingLabelTextField)?.title)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddOnYourOwnVC: UITextViewDelegate {
    
}
