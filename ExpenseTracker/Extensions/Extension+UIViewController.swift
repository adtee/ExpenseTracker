//
//  Extension+UIViewController.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: Alertview
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputTypeSecure:Bool? = false,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.isSecureTextEntry = inputTypeSecure ?? false
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDialog(title:String?,Message:String,actiontitle:String,actionHandler:((UIAlertAction) -> Swift.Void)? = nil){
        let alert = UIAlertController(title: title ?? "Expense Tracker", message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: actionHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Storyboard
    class func instantiate<T: UIViewController>(appStoryboard: StoryboardName) -> T {
        
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
}
