//
//  BaseButton.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/22.
//

import UIKit

@IBDesignable
class BaseButton: UIView, NibLoadable {
    @IBOutlet weak var button: UIButton!
    var onSelected: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    @IBAction func onTouchUpInside(_ sender: Any) {
        onSelected?()
    }
}
