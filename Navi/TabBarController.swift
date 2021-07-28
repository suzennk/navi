//
//  TabBarController.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

/**
 Custom Tab Bar Controller for Navi App
 */
class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [UIColor] = [.blue, .red, .orange, .purple, .green]
        colors.forEach { color in
            let vc = ViewController()
            vc.view.backgroundColor = color
            vc.title = color.accessibilityName
            self.addChild(vc)
        }
        
    }
    
}
