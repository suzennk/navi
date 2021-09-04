//
//  AddOnYourOwnVC.swift
//  Navi
//
//  Created by Susan Kim on 2021/09/04.
//

import UIKit
import PanModal

class AddNavigationController: UINavigationController, PanModalPresentable {
    private let addVC = AddOnYourOwnVC()
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [addVC]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class AddOnYourOwnVC: ViewController, PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "OYO 추가하기"
        
        view.backgroundColor = .white
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        
    }
}
