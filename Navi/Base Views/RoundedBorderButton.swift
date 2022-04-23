//
//  RoundedBorderButton.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/23.
//

import UIKit

class RoundedBorderButton: UIView, NibLoadable {    
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}
