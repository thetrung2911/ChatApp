//
//  LoginPotocol.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation

protocol LoginPotocol: NSObjectProtocol {
    func loginFail(error:String)
    func loginSuccesFully()
}
