//
//  UIApplicationExtension.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/27/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation
import SVProgressHUD

extension UIApplication {
    
    ///Show alert with OK button
    func showAlertWithOneButton(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    ///Show loading progress
    func showLoadingProgress() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.none)
    }
}
