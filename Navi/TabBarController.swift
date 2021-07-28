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
        let viewControllers = colors.map { color -> UIViewController in
            let vc = ViewController()
            vc.view.backgroundColor = color
            let navContr = UINavigationController(rootViewController: vc)
            navContr.title = color.accessibilityName
            return navContr
        }
        
        self.viewControllers = viewControllers
    }
    
}
