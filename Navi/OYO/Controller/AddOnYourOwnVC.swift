//
//  AddOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit
import PanModal
import SkyFloatingLabelTextField

enum VerseContents: Int, CaseIterable, RawRepresentable {
    case head
    case bible
    case chapter
    case startVerse
    case endVerse
    case content

    var text: String {
        switch self {
        case .head:         return "카테고리"
        case .bible:        return "성경"
        case .chapter:      return "장"
        case .startVerse:   return "절(시작)"
        case .endVerse:     return "절(끝)"
        case .content:      return "내용"
        }
    }
    
    var isValid: (_ text: String)->(Bool) {
        switch self {
        case .head:         fallthrough
        case .bible:        fallthrough
        case .content:
            return { text in
                return text != ""
            }
        case .chapter:      fallthrough
        case .startVerse:
            return { text in
                return Int(text) != nil
            }
        case .endVerse:
            return { text in
                return text == "" || Int(text) != nil
            }
        }
    }
    
    var errorMessage: String {
        switch self {
        case .head:         fallthrough
        case .bible:        fallthrough
        case .content:
            return "\(self.text) 항목을 입력해주세요."
        case .chapter:      fallthrough
        case .startVerse:   fallthrough
        case .endVerse:
            return "숫자를 올바르게 입력해주세요."
        }
    }
    
    var textField: SkyFloatingLabelTextField {
        let tf = SkyFloatingLabelTextField()
        tf.title = self.text
        tf.placeholder = self.text
        tf.disabledColor = .systemGray6
        tf.selectedLineColor = .naviYellow
        tf.selectedTitleColor = .naviYellow
//        switch self {
//        case .startChapter:   fallthrough
//        case .startVerse:     fallthrough
//        case .endChapter:     fallthrough
//        case .endVerse:
//            tf.keyboardType = .numberPad
//        case .theme:          fallthrough
//        case .bible:
//            tf.inputView = UIPickerView()
//        case .content: break
//        }
        return tf
    }
}

class AddOnYourOwnVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellId = "cellId"
    public var delegate: OnYourOwnTableVC? = nil
    
    let cases = VerseContents.allCases
    lazy var textFields: [SkyFloatingLabelTextField] = VerseContents.allCases.map {
        let tf = $0.textField
        tf.delegate = self
        tf.tag = $0.rawValue
        return tf
    }
    
    lazy var cancelButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = .systemGray
        b.addTarget(self, action: #selector(handleCancelTapped), for: .touchUpInside)
        b.backgroundColor = .systemGray5.withAlphaComponent(0.3)
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
        b.backgroundColor = .systemGray5.withAlphaComponent(0.3)
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
        
        addObversers()
    }
    
     override func configureConstraints() {
        let titleLabel = UILabel()
        titleLabel.text = "On Your Own"
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        
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
    
    deinit {
        removeObservers()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func addObversers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        tableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }
    
    @objc private func handleCancelTapped() {
        self.dismiss(animated: true) {
            self.delegate?.addVC = AddOnYourOwnVC()
        }
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
    
    @objc private func handleDoneTapped() {
        if textFields.enumerated().filter({ offset, tf in
            guard let text = tf.text, let type = VerseContents(rawValue: offset) else { return true }
            if type.isValid(text) { return false }
            else {
                tf.errorMessage = type.errorMessage
                return true
            }
        }).count > 0 {
            return
        }
        
        let texts = textFields.map { $0.text ?? "" }
        
        let chapter = Int(texts[VerseContents.chapter.rawValue]) ?? 0
        let startVerse = Int(texts[VerseContents.startVerse.rawValue]) ?? 0
        let endVerse = Int(texts[VerseContents.chapter.rawValue])
        
        let res = DataBaseService.shared.addOYOVerse(
            bible: texts[VerseContents.bible.rawValue],
            chapter: chapter,
            startVerse: startVerse,
            middleSymbol: endVerse == nil ? nil : "-",
            endVerse: endVerse ?? 0,
            head: texts[VerseContents.head.rawValue],
            contents: texts[VerseContents.content.rawValue]
        )
        
        switch res {
        case .success(_):
            self.dismiss(animated: true) {
                // MARK: Reload Data 안됨
                self.delegate?.oyoVerses = DataBaseService.shared.categorizedOyoVerses
                self.delegate?.tableView.reloadData()
                self.delegate?.addVC = AddOnYourOwnVC()
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text else { return }
        if let tf = textField as? SkyFloatingLabelTextField, let contentType = VerseContents(rawValue: tf.tag) {
            
            if contentType.isValid(text) {
                tf.errorMessage = ""
            } else {
                tf.errorMessage = contentType.errorMessage
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        if tag < textFields.count - 1 {
            textFields[tag+1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
