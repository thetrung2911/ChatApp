//
//  RegisterPotocol.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation

protocol RegisterPotocol: NSObjectProtocol {
    
    func registerSuccesFully()
    func createUserFail()
    func existsFail()
    func uploadProfilePictureFail(_ error: Error)
    func uploadProfilePictureSuccess(_ downloadUrl: String)
}
