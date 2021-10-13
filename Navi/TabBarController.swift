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
        
        let myPageVC = MyPageVC()
        let myNavContr = UINavigationController(rootViewController: myPageVC)
        
        self.viewControllers = [oyoNavContr, homeNavController, myNavContr]
        
        tabBar.items?[0].image = UIImage(named: "oyo")?.withTintColor(.darkText, renderingMode: .alwaysTemplate)
        tabBar.items?[0].selectedImage = UIImage(named: "oyo")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[1].image = UIImage(named: "home")?.withTintColor(.darkText, renderingMode: .alwaysTemplate)
        tabBar.items?[1].selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[2].image = UIImage(named: "my-page")?.withTintColor(.darkText, renderingMode: .alwaysTemplate)
        tabBar.items?[2].selectedImage = UIImage(named: "my-page")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?.forEach({
            $0.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        })
        
        self.selectedViewController = viewControllers?[1]
        
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
    }
    
}
