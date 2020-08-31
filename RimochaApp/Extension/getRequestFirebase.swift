//
//  getRequestFirebase.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import FirebaseAuth

extension DataService
{
    func loginFirebase(email: String, password: String,success: @escaping (Bool) -> Void ,failure:@escaping (String) -> Void)
    {
        Auth.auth().signIn(withEmail: email , password: password, completion:{ (authResul, error) in
            if let error = error as NSError?{
                failure(error.localizedDescription)
            }else{
                success(true)
            }
        })
    }
    
    func registerFirebase(email: String, password: String,success: @escaping (Bool) -> Void ,failure:@escaping (String) -> Void)
    {
        Auth.auth().createUser(withEmail: email , password: password, completion:{ (authResul, error) in
            if let error = error as NSError?{
                failure(error.localizedDescription)
            }else{
                success(true)
            }
        })
    }
    
}
