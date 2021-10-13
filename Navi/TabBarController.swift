//
//  TabBarController.swift
//  Navi
//
//  Created by Susan Kim on 2021/07/28.
//

import UIKit

/**
 Custom Tab Bar Controller for Navi App. Also a root view controller of this app.
 */
class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let quizVC = QuizVC()
//        let quizNavController = UINavigationController(rootViewController: quizVC)
//        quizNavController.title = "Quiz"
        
        let homeVC = HomeVC()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.title = "Home"
        
        /*
        let myPageVC = MyPageVC()
        let myPageNavController = UINavigationController(rootViewController: myPageVC)
        myPageNavController.title = "MyPage"
        */
        
        /*
        let tv = CardTableVC()
        let navcontr = UINavigationController(rootViewController: tv)
        tv.title = "암송하기"
        tv.viewModel = CardTableViewModel(["A - 새로운 삶", "B - 그리스도를 전파함"])

        self.viewControllers = [quizNavController, homeNavController, myPageNavController, navcontr]
        self.selectedViewController = viewControllers?[3]
        */
        
        let oyoVC = OnYourOwnTableVC()
        let oyoNavContr = UINavigationController(rootViewController: oyoVC)
        oyoNavContr.title = "OYO"
        
        let myPageVC = MyPageVC()
        let myNavContr = UINavigationController(rootViewController: myPageVC)
        myNavContr.title = "MY"
        
        self.viewControllers = [oyoNavContr, homeNavController, myNavContr]
        self.selectedViewController = viewControllers?[1]
    }
    
}
