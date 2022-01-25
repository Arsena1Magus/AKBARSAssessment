//
//  AuthorizationPresenter.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 30.08.2021.
//

import UIKit

class AuthorizationPresenter {
    var interactor: AuthorizationInteractor = AuthorizationInteractor()
    
    private var parentVC: UIViewController = UIViewController()
    private var login: String = ""
    
    func authorization(login: String, password: String, from viewController: UIViewController) {
        parentVC = viewController
        self.login = login
        interactor.presenter = self
        interactor.getSignin(login: login, password: password.sha256())
    }
    
    func showTestList() {
        (parentVC as? AuthorizationViewController)?.stopLoader()
        let storyBoard: UIStoryboard = UIStoryboard(name: "TestListViewController", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TestListViewController") as! TestListViewController
        vc.presenter.login = login
        vc.modalPresentationStyle = .fullScreen
        parentVC.present(vc, animated: false, completion: nil)
    }
    
    func showAlert(title: String, _ msg: String) {
        (parentVC as? AuthorizationViewController)?.stopLoader()
        parentVC.showAlert(title: title, msg: msg, buttonText: "Понятно", handler: nil)
    }
}
