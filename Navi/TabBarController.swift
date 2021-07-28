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
        
        let colors: [UIColor] = [.blue, .orange, .purple]
        var viewControllers = colors.map { color -> UIViewController in
            let vc = ViewController()
            vc.view.backgroundColor = color
            let navContr = UINavigationController(rootViewController: vc)
            navContr.title = color.accessibilityName
            return navContr
        }
        
        let quizVC = QuizVC()
        let quizNavController = UINavigationController(rootViewController: quizVC)
        quizNavController.title = "Quiz"
        
        let homeVC = HomeVC()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.title = "Home"
        
        viewControllers[0] = quizNavController
        viewControllers[1] = homeNavController
        
        self.viewControllers = viewControllers
    }
    
}
