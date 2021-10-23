//
//  AddOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit
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

class AddOnYourOwnVC: ViewController {

    unowned var delegate: OnYourOwnTableVC?

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryErrorLabel: UILabel!
    
    @IBOutlet weak var selectBibleButton: UIButton!
    @IBOutlet weak var bibleErrorLabel: UILabel!
    
    @IBOutlet weak var chapterTextField: UITextField!
    @IBOutlet weak var startVerseTextField: UITextField!
    @IBOutlet weak var endVerseTextField: UITextField!
    @IBOutlet weak var rangeErrorLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentErrorLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBibles()
        
        addObversers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCategories()
    }
    
    deinit {
        removeObservers()
    }
    
    func setupViews() {
        categoryTextField.isHidden = true
        categoryErrorLabel.isHidden = true
        bibleErrorLabel.isHidden = true
        rangeErrorLabel.isHidden = true
        contentErrorLabel.isHidden = true
    }
    
    func setupBibles() {
        let items = Bible.bibles.map { bible in
            return UIAction(title: bible.title) { a in
                self.selectBibleButton.setTitle(a.title, for: .normal)
            }
        }
        let menu = UIMenu(title: "", options: .displayInline, children: items)
        
        selectBibleButton.menu = menu
    }
    
    func setupCategories() {
        let headItems = DataBaseService.shared.oyoHeads.map { head in
            return UIAction(title: head) { a in
                self.handleSelectCategory(a.title)
                self.categoryTextField.text = a.title
                self.categoryTextField.isHidden = true
            }
        }
        
        let item = UIAction(title: "직접입력", image: nil, identifier: nil) { a in
            self.handleSelectCategory(a.title)
            self.categoryTextField.text = ""
            self.categoryTextField.isHidden = false
        }
        
        
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: headItems + [item])
        
        selectCategoryButton.menu = menu
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.addVC = AddOnYourOwnVC(nibName: "AddOnYourOwnVC", bundle: nil)
        }
    }
    
    @objc func handleSelectCategory(_ category: String) {
        selectCategoryButton.setTitle(category, for: .normal)
    }
}

//- MARK: Keyboard Observers
extension AddOnYourOwnVC {
    func addObversers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

/*
class AddOnYourOwnVC: ViewController, UITableViewDelegate, UITableViewDataSource {

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
*/
