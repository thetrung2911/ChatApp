//
//  LoginViewController.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/27/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController, LoginPotocol, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    let mLoginPresenter: LoginPresenter = LoginPresenter.init(loginFirebase: DataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        settingLayout()
        // Do any additional setup after loading the view.
        mLoginPresenter.attactLoginPresenter(view: self)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        loginButton.setCornerRadius()
        registerButton.setCornerRadius()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// Setting Layout View
    func settingLayout() {
        errorLabel.isHidden = true
        
    }
    
    /// action login
    @IBAction func onLogin(_ sender: Any) {
        login()
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let storyboard = UIStoryboard(name: registerStoryboardName, bundle: nil)
        let vc = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: registerViewControllerIdentifier))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func login() {
        errorLabel.isHidden = true
        if emailTextField.text == "" {
            showTextError(error: emailEmptyText)
        } else if !emailTextField.text!.isEmail {
            showTextError(error: validateEmailText)
        } else if passwordTextField.text == "" {
            showTextError(error: passwordEmptyText)
        } else {
            guard let email = emailTextField.text, let password = passwordTextField.text else { return }
            mLoginPresenter.login(email: email, password: password)
        }
    }
    
    func loginFail(error: String) {
        self.showTextError(error: error)
    }
    
    func loginSuccesFully() {
        let storyboard = UIStoryboard(name: homeStoryboardName, bundle: nil)
        let vc = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: homeViewControllerIdentifier))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    /// Show text error
    func showTextError(error:String){
        errorLabel.isHidden = false
        errorLabel.text = error
        print("VNC",error)
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }else{
            login()
            textField.resignFirstResponder()
        }
        return true
    }
}
