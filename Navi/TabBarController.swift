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
                
        let homeVC = HomeVC()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        let oyoVC = OnYourOwnTableVC()
        let oyoNavContr = UINavigationController(rootViewController: oyoVC)
        
        let storyboard = UIStoryboard(name: "Quiz", bundle: nil)
        let quizNavController = storyboard.instantiateViewController(withIdentifier: "quizNavController")
        
        let myPageVC = MyPageVC()
        let myNavController = UINavigationController(rootViewController: myPageVC)
        
        self.viewControllers = [oyoNavContr, homeNavController, quizNavController, myNavController]
        
        tabBar.items?[0].image = UIImage(named: "oyo-u")?.withTintColor(.label, renderingMode: .alwaysTemplate)
        tabBar.items?[0].selectedImage = UIImage(named: "oyo")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[1].image = UIImage(named: "home-u")?.withTintColor(.label, renderingMode: .alwaysTemplate)
        tabBar.items?[1].selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[2].image = UIImage(named: "quiz-u")?.withRenderingMode(.alwaysTemplate)
        tabBar.items?[2].selectedImage = UIImage(named: "quiz-sel")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].image = UIImage(named: "my-u")?.withTintColor(.label, renderingMode: .alwaysTemplate)
        tabBar.items?[3].selectedImage = UIImage(named: "my")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?.forEach({
            $0.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        })
        
        self.selectedViewController = viewControllers?[1]
        
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        
        if #available(iOS 15, *) {
           let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .clear
           tabBar.standardAppearance = tabBarAppearance
           tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            tabBar.barTintColor = .clear
         }
    }
    
}
