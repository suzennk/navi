//
//  UIFont+Extension.swift
//  Navi
//
//  Created by Susan Kim on 2021/10/19.
//

import UIKit

extension UIFont {
    static func preferredFont(forTextStyle: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: forTextStyle)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: forTextStyle)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
        
    }
}
