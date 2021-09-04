//
//  NaviInputTextField.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit

class NaviInputTextField: UITextField {
    
    var inputName: String = "" {
        didSet {
            updateView()
        }
    }
    
    private let leftLabel: UILabel = {
        let label = PaddingLabel(frame: .zero)
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    init(name: String) {
        super.init(frame: .zero)
   
        inputName = name
        
        leftView = leftLabel
        leftViewMode = .always
        
        configureConstraints()
        updateView()
    }
    
    func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
        leftLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
    }
    
    func updateView() {
        leftLabel.text = "\(inputName) "
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PaddingLabel: UILabel {

   @IBInspectable var topInset: CGFloat = 8.0
   @IBInspectable var bottomInset: CGFloat = 8.0
   @IBInspectable var leftInset: CGFloat = 8.0
   @IBInspectable var rightInset: CGFloat = 8.0

   override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
   }

   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += topInset + bottomInset
         contentSize.width += leftInset + rightInset
         return contentSize
      }
   }
}
