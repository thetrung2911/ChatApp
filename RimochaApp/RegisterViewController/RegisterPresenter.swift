//
//  RegisterPresenter.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import FirebaseAuth

class RegisterPresenter {
    private weak var registerPotocol: RegisterPotocol?
    private let authFirebaseRegister: DataService?
    
    init(reegisterFirebase: DataService) {
        self.authFirebaseRegister = reegisterFirebase
    }
    
    func attactLoginPresenter(view: RegisterPotocol)
    {
        self.registerPotocol = view
    }
    
    func register(user: UserManager) {
        DatabaseManager.shared.userExists(with: user.emailAddress, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            guard !exists else {
                // user already exists
                strongSelf.registerPotocol?.existsFail()
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: user.emailAddress, password: user.password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    strongSelf.registerPotocol?.createUserFail()
                    return
                }
                
                // insert user in database
                DatabaseManager.shared.insertUser(with: user) { (success) in
                    if success {
                        // upload image
                        guard let data = user.avatar.pngData() else {
                                return
                        }
                        let filename = user.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                strongSelf.registerPotocol?.uploadProfilePictureSuccess(downloadUrl)
                            case .failure(let error):
                                strongSelf.registerPotocol?.uploadProfilePictureFail(error)
                            }
                        })
                    }
                }
                strongSelf.registerPotocol?.registerSuccesFully()
            })
        })
    }
}
