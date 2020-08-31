//
//  LoginPresenter.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import SVProgressHUD

class LoginPresenter {
    private var loginModel: UserManager?
    private weak var loginPotocol: LoginPotocol?
    private let authFirebaseLogin: DataService?
    
    init(loginFirebase: DataService) {
        self.authFirebaseLogin = loginFirebase
    }
    
    func attactLoginPresenter(view: LoginPotocol)
    {
        self.loginPotocol = view
    }
    
    func login(email:String,password:String) {
        UIApplication.shared.showLoadingProgress()
        authFirebaseLogin?.loginFirebase(email: email, password: password, success: { (autheResult) in
            self.successLogin()
        }) { (error) in
            self.failLogin(error: error)
        }
        
    }
    
    private func failLogin(error:String){
        SVProgressHUD.dismiss()
        loginPotocol?.loginFail(error: error)
    }
    
    private func successLogin(){
        SVProgressHUD.dismiss()
        loginPotocol?.loginSuccesFully()
    }
    
}
