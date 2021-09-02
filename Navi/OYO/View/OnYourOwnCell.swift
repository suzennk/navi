//
//  OnYourOwnCell.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/02.
//

import UIKit

class OnYourOwnCell: UITableViewCell {
    var viewModel: VerseViewModel? {
        didSet {
            textLabel?.text = viewModel?.rangeText
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = .systemFont(ofSize: 20)
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}