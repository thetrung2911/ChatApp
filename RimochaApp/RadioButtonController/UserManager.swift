//
//  UserManager.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/31/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import UIKit

struct UserManager {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let password: String
    let sex: Int
    let avatar: UIImage
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    var profilePictureFileName: String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}
