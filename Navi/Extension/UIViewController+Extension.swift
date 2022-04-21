//
//  UIViewController+Extensino.swift
//  Navi
//
//  Created by Susan Kim on 2021/12/14.
//

import UIKit

extension UIViewController {
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    /// only 'title' is required parameter. you can ignore rest of them
    ///
    /// - Parameters:
    ///   - title: Title string. required.
    ///   - message: Message for alert.
    ///   - okTitle: Title for confirmation action. If you don't probide 'okHandler', this will be ignored.
    ///   - okHandler: Closure for confirmation action. If it's implemented, alertController will have two alertAction.
    ///   - cancelTitle: Title for cancel/dissmis action.
    ///   - cancelHandler: Closure for cancel/dissmis action.
    ///   - completion: Closure will be called right after the alertController presented.
    func alert(title: String,
               message: String? = nil,
               okTitle: String = "OK",
               okHandler: AlertActionHandler? = nil,
               cancelTitle: String? = nil,
               cancelHandler: AlertActionHandler? = nil,
               completion: (() -> Void)? = nil) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let okClosure = okHandler {
            let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default, handler: okClosure)
            alert.addAction(okAction)
            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
            alert.addAction(cancelAction)
        } else {
            if let _ = cancelTitle {
                let cancelAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
                alert.addAction(cancelAction)
            } else {
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: cancelHandler)
                alert.addAction(cancelAction)
            }
            
        }
        self.present(alert, animated: true, completion: completion)
    }
}
