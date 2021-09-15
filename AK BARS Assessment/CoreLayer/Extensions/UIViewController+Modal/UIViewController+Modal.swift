//
//  UIViewController+Modal.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 01.09.2021.
//

import UIKit

extension UIViewController {    
    func present(modalViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        modalViewController.modalPresentationStyle = .overCurrentContext
        self.present(modalViewController, animated: animated, completion: completion)
    }
    
    func present(from viewController: UIViewController, animated: Bool) {
        self.modalPresentationStyle = .fullScreen
        viewController.navigationController?.pushViewController(self, animated: animated)
    }
    
    func showAlert(title: String, msg: String, buttonText: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if let view = alertController.view {
            view.accessibilityIdentifier = "System alert"
        }
        let cancel = UIAlertAction(title: buttonText, style: .cancel, handler: handler)
        cancel.titleTextColor = UIColor(red: 0.133, green: 0.745, blue: 0.329, alpha: 1)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
