//
//  EditOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/12/14.
//

import UIKit

class EditOnYourOwnVC: AddOnYourOwnVC {
    unowned var delegate: OYODetailVC?
    
    var originalVerse: Verse?
    
    init() {
        super.init(nibName: "AddOnYourOwnVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "암송카드 수정하기"
        
        guard let verse = originalVerse else { return }
        
        selectCategoryButton.setTitle(verse.head, for: .normal)
        categoryTextField.text = verse.head
        titleTextField.text = verse.title
        selectBibleButton.setTitle(verse.bible, for: .normal)
        chapterTextField.text = "\(verse.chapter)"
        startVerseTextField.text = "\(verse.startVerse)"
        middleSymbolButton.setTitle(verse.middleSymbol, for: .normal)
        endVerseTextField.text = "\(verse.endVerse)"
        contentTextView.text = verse.contents
    }
    
    override func commitChanges() {
        guard let verse = originalVerse else {
            debugPrint("Original verse missing ...")
            return
        }
        
        verse.setValue(selectBibleButton.currentTitle, forKey: "bible")
        verse.setValue(Int(chapterTextField.text!), forKey: "chapter")
        verse.setValue(Int(startVerseTextField.text!), forKey: "startVerse")
        verse.setValue(Int(endVerseTextField.text!) == nil ? nil : middleSymbolButton.currentTitle, forKey: "middleSymbol")
        verse.setValue(Int(endVerseTextField.text!), forKey: "endVerse")
        verse.setValue(categoryTextField.text, forKey: "head")
        verse.setValue(contentTextView.text, forKey: "contents")
        
        switch DataBaseService.shared.save() {
        case .failure:
            debugPrint("수정 실패")
            fallthrough
        case .success:
            delegate?.verse = verse
            self.dismiss(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
