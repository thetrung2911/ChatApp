//
//  RegisterViewController.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController, RegisterPotocol, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightContainerView: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    private let radioController: RadioButtonController = RadioButtonController()
    private let mRegisterPresenter = RegisterPresenter.init(reegisterFirebase: DataService())
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var intersexButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var keyboardHeight: CGFloat = 0
    private var activeField: UITextField?
    private var lastOffset: CGPoint?
    
    private var sex = 1
    private var avatarImage: UIImage = UIImage(named: "male_user")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        settingLayout()
        
        mRegisterPresenter.attactLoginPresenter(view: self)
        radioController.buttonsArray = [maleButton,femaleButton,intersexButton]
        radioController.defaultButton = maleButton
        
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        rePasswordTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        registerButton.setCornerRadius()
        
    }
    
    // setting layout view
    private func settingLayout() {
        if #available(iOS 13.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backLoginAction))
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func backLoginAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // add notification show and hide keybroad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// remove notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onRegister(_ sender: Any) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repassword = rePasswordTextField.text,
            !email.isEmpty,
            !password.isEmpty,
            !firstName.isEmpty,
            !lastName.isEmpty,
            password.count >= 6,
            repassword.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        // check repassword
        if repassword != password {
            alertUserLoginError(message: "Password does not match")
            return
        }
        UIApplication.shared.showLoadingProgress()
        let user = UserManager(firstName: firstName, lastName: lastName, emailAddress: email, password: password, sex: self.sex, avatar: avatarImage)
        // Firebase Register
        mRegisterPresenter.register(user: user)
    }
    
    @IBAction func onFemaleAction(_ sender: UIButton) {
        self.sex = 0
        guard let image = UIImage(named: maleUser) else { return }
        avatarImage = image
        radioController.buttonArrayUpdated(buttonSelected: sender)
    }
    
    @IBAction func onMaleAction(_ sender: UIButton) {
        self.sex = 1
        guard let image = UIImage(named: maleUser) else { return }
        avatarImage = image
        radioController.buttonArrayUpdated(buttonSelected: sender)
    }
    
    @IBAction func onIntersexAction(_ sender: UIButton) {
        self.sex = 2
        guard let image = UIImage(named: maleUser) else { return }
        avatarImage = image
        radioController.buttonArrayUpdated(buttonSelected: sender)
    }
    
    func uploadProfilePictureSuccess(_ downloadUrl: String) {
        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
        print(downloadUrl)
    }
    
    func uploadProfilePictureFail(_ error: Error) {
        print("Storage manager error: \(error)")
    }
    
    func existsFail() {
        SVProgressHUD.dismiss()
        alertUserLoginError(message: "Looks like a user account for that email address already exists.")
    }
    func createUserFail() {
        SVProgressHUD.dismiss()
        print("Error creating user")
    }
    
    func registerSuccesFully() {
        SVProgressHUD.dismiss()
        let storyboard = UIStoryboard(name: homeStoryboardName, bundle: nil)
        let nav = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: homeViewControllerIdentifier))
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.heightContainerView.constant += self.keyboardHeight
            })
            
            // move if keyboard hide input field
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                // no collapse
                return
            }
            
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset!.x, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            guard let lastOffset = self.lastOffset else { return }
            self.heightContainerView.constant -= self.keyboardHeight
            self.scrollView.contentOffset = lastOffset
        }
        
        self.keyboardHeight = 0
    }
    
    /// Alert Error
    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            rePasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
