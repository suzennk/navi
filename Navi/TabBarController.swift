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
        
        let quizVC = QuizVC()
        let quizNavController = UINavigationController(rootViewController: quizVC)
        quizNavController.title = "Quiz"
        
        let homeVC = HomeVC()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.title = "Home"
        
        let myPageVC = MyPageVC()
        let myPageNavController = UINavigationController(rootViewController: myPageVC)
        myPageNavController.title = "MyPage"
        
        self.viewControllers = [quizNavController, homeNavController, myPageNavController]
    }
    
}
