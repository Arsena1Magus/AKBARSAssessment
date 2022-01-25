//
//  AuthorizationViewController.swift
//  AK BARS Assessment
//
//  Created by Никита Петров on 30.08.2021.
//

import UIKit

class AuthorizationViewController: UIViewController {
    var presenter: AuthorizationPresenter = AuthorizationPresenter()
    
    @IBOutlet private var entryButton: UIButton! {
        didSet {
            entryButton.layer.cornerRadius = 6
            entryButton.backgroundColor = UIColor(red: 0.51, green: 0.875, blue: 0.58, alpha: 1)
            entryButton.setTitle("ВОЙТИ", for: .normal)
            entryButton.tintColor = .white
        }
    }

    @IBOutlet private var separator2View: UIView!
    @IBOutlet private var passwordTextField: UITextField! {
        didSet {
            passwordTextField.textColor = .black
            passwordTextField.placeholder = "Пароль"
            passwordTextField.borderStyle = .none
            passwordTextField.autocorrectionType = .no;
        }
    }
    @IBOutlet private var passwordTitleLabel: UILabel! {
        didSet {
            passwordTitleLabel.text = "Пароль"
            passwordTitleLabel.textColor = mainColor
            passwordTitleLabel.isHidden = true
        }
    }
    @IBOutlet private var hiddenPasswordButton: UIButton! {
        didSet {
            hiddenPasswordButton.setImage(UIImage(named: "unhide"), for: .normal)
        }
    }
    
    @IBOutlet private var loginTitleLabel: UILabel! {
        didSet {
            loginTitleLabel.text = "Логин"
            loginTitleLabel.textColor = mainColor
            loginTitleLabel.isHidden = true
        }
    }
    @IBOutlet private var loginTextField: UITextField! {
        didSet {
            loginTextField.autocorrectionType = .no;
            loginTextField.textColor = .black
            loginTextField.placeholder = "Логин"
            loginTextField.borderStyle = .none
        }
    }
    @IBOutlet private var separator1View: UIView!
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var loader: UIActivityIndicatorView!
    @IBOutlet private var hint1Label: UILabel! {
        didSet {
            hint1Label.textColor = hintTextColor
            hint1Label.text = "Какой логин и пароль вводить?"
        }
    }
    @IBOutlet private var hint2Label: UILabel! {
        didSet {
            hint2Label.textColor = hintTextColor
            hint2Label.text = "Забыли пароль?"
        }
    }
    @IBOutlet private var hint3Label: UILabel! {
        didSet {
            hint3Label.textColor = hintTextColor
            hint3Label.text = "У меня нет регистрации в Ак Барс Трейд"
        }
    }
    @IBOutlet private var hint1Image: UIImageView!
    @IBOutlet private var hint2Image: UIImageView!
    @IBOutlet private var hint3Image: UIImageView!
    
    // MARK: - IBActions
    @IBAction private func taphint1Button() {
        self.showAlert(title: "Необходимо ввести логин и пароль от мобильного приложения АК БАРС Трейд", msg: "", buttonText: "Понятно", handler: nil)
    }
    
    @IBAction private func taphint2Button() {
        self.showAlert(title: "Восстановить пароль можно через мобильное приложение Ак Барс трейд", msg: "", buttonText: "Понятно", handler: nil)
    }
    
    @IBAction private func taphint3Button() {
        self.showAlert(title: "Для прохождения тестирования вам нужно скачать мобильное приложение Ак Барс трейд и зарегистрироваться в нем", msg: "", buttonText: "Понятно", handler: nil)
    }

    @IBAction private func tapEntryButton() {
        if !login.isEmpty && !password.isEmpty {
            startLoader()
            presenter.authorization(login: login, password: password, from: self)
        }
    }
    
    @IBAction private func tapHiddenPasswordButton() {
        isHiddenPassword = !isHiddenPassword
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if isHiddenPassword {
            hiddenPasswordButton.setImage(UIImage(named: "unhide"), for: .normal)
        } else {
            hiddenPasswordButton.setImage(UIImage(named: "hide"), for: .normal)
        }
    }
    
    @objc func loginDoneButtonAction(){
        loginTextField.resignFirstResponder()
    }
    
    @objc func passwordDoneButtonAction(){
        passwordTextField.resignFirstResponder()
    }
    
    private var login: String = ""
    private var password: String = ""
    private var isHiddenPassword: Bool = true
    private var hintImg: String = "hint"
    private var mainColor: UIColor = UIColor(red: 0.133, green: 0.745, blue: 0.329, alpha: 1)
    private var hintTextColor: UIColor = UIColor(red: 0.416, green: 0.416, blue: 0.416, alpha: 1)
    private var separatorColor: UIColor = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: "auth_background")
        mainImageView.image = UIImage(named: "auth_main_image")
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        separator2View.backgroundColor = separatorColor
        separator1View.backgroundColor = separatorColor
        
        setupImageHints()
        setuoLoginAddDoneButtonOnKeyboard()
        setupPasswordAddDoneButtonOnKeyboard()
    }
    
    private func setupImageHints() {
        hint1Image.image = UIImage(named: hintImg)
        hint2Image.image = UIImage(named: hintImg)
        hint3Image.image = UIImage(named: hintImg)
    }

    private func setuoLoginAddDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.loginDoneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        loginTextField.inputAccessoryView = doneToolbar
    }
    
    private func setupPasswordAddDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.passwordDoneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        passwordTextField.inputAccessoryView = doneToolbar
    }
    
    func startLoader() {
        loader.startAnimating()
    }
    
    func stopLoader() {
        loader.stopAnimating()
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            login = textField.text ?? ""
        } else if textField == passwordTextField {
            password = textField.text ?? ""
        }
        
        if !login.isEmpty && !password.isEmpty {
            entryButton.backgroundColor = mainColor
        } else {
            entryButton.backgroundColor = UIColor(red: 0.51, green: 0.875, blue: 0.58, alpha: 1)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        if textField == loginTextField {
            if range.location >= 0 {
                if (range.length == 1 && string.isEmpty) && range.location == 0 {
                    loginTitleLabel.isHidden = true
                } else {
                    loginTitleLabel.isHidden = false
                }
            } else {
                loginTitleLabel.isHidden = true
            }
        } else if textField == passwordTextField {
            if range.location >= 0 {
                if (range.length == 1 && string.isEmpty) && range.location == 0 {
                    passwordTitleLabel.isHidden = true
                } else {
                    passwordTitleLabel.isHidden = false
                }
            } else {
                passwordTitleLabel.isHidden = true
            }
        }
        return true
    }
}
