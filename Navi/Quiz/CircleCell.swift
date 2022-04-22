//
//  CircleCell.swift
//  Navi
//
//  Created by Susan Kim on 2022/04/22.
//

import UIKit

class CircleCell: UICollectionViewCell {
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var subheadLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                headLabel.layer.borderWidth = 2
                headLabel.layer.borderColor = UIColor.naviYellow.cgColor
                headLabel.backgroundColor = .systemBackground
            } else {
                headLabel.layer.borderWidth = 0
                headLabel.backgroundColor = .systemGray5
            }
        }
    }
}
