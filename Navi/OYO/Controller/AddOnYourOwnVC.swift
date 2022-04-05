//
//  AddOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit

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
}

class AddOnYourOwnVC: ViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryErrorLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var selectBibleButton: UIButton!
    @IBOutlet weak var bibleErrorLabel: UILabel!
    
    @IBOutlet weak var chapterTextField: UITextField!
    @IBOutlet weak var startVerseTextField: UITextField!
    @IBOutlet weak var middleSymbolButton: UIButton!
    @IBOutlet weak var endVerseTextField: UITextField!
    @IBOutlet weak var rangeErrorLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentErrorLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldDelegates()
        
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
        let items = Bible.allCases.map { bible in
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
    
    @IBAction func handleCancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func commitChanges() {
        let res = DataBaseService.shared.addOYOVerse(
            bible: selectBibleButton.currentTitle!,
            chapter: Int(chapterTextField.text!) ?? 0,
            startVerse: Int(startVerseTextField.text!) ?? 0,
            middleSymbol: Int(endVerseTextField.text!) == nil ? nil : middleSymbolButton.currentTitle,
            endVerse: Int(endVerseTextField.text!),
            head: categoryTextField.text!,
            title: titleTextField.text!,
            contents: contentTextView.text
        )
        
        switch res {
        case .success(_):
            self.dismiss(animated: true)
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
    @IBAction func handleDoneTapped(_ sender: Any) {
        categoryErrorLabel.isHidden = categoryTextField.text != ""
        bibleErrorLabel.isHidden = selectBibleButton.currentTitle != "선택"
        rangeErrorLabel.isHidden = [chapterTextField.text!, startVerseTextField.text!].compactMap { Int($0) }.count == 2
        contentErrorLabel.isHidden = contentTextView.text != ""
        
        guard [categoryErrorLabel, bibleErrorLabel, rangeErrorLabel, contentErrorLabel].filter({ !$0.isHidden }).isEmpty else { return }
        
        commitChanges()
    }
    
    @objc func handleSelectCategory(_ category: String) {
        selectCategoryButton.setTitle(category, for: .normal)
    }
    
    @IBAction func handleMiddleSymbolButtonTapped(_ sender: Any) {
        if let text = endVerseTextField.text, text == "" {
            // end verse 비어있으면 middle symbol 없음
            middleSymbolButton.setTitle("", for: .normal)
        } else if middleSymbolButton.currentTitle == "-" {  // end verse 입력되어 있음
            // middle symbol toggle [-] -> [,]
            middleSymbolButton.setTitle(",", for: .normal)
        } else if middleSymbolButton.currentTitle == "," {
            // middle symbol toggle [,] -> [-]
            middleSymbolButton.setTitle("-", for: .normal)
        } else {
            middleSymbolButton.setTitle("-", for: .normal)
        }
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

extension AddOnYourOwnVC: UITextFieldDelegate {
    func setupTextFieldDelegates() {
        endVerseTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing ")
        if let text = textField.text, text.isEmpty {
            middleSymbolButton.setTitle("", for: .normal)
        } else {
            if middleSymbolButton.currentTitle == "" {
                middleSymbolButton.setTitle("-", for: .normal)
            }
        }
    }
}
