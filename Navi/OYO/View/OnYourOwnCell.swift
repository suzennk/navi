//
//  OnYourOwnCell.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/02.
//

import UIKit

class OnYourOwnCell: UITableViewCell {
    var viewModel: OYOCellViewModel? {
        didSet {
            textLabel?.text = viewModel?.rangeText
            detailTextLabel?.text = viewModel?.content
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = .preferredFont(forTextStyle: .body)
        detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
        detailTextLabel?.textColor = .systemGray
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
