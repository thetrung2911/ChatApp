//
//  UIButtonExtension.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/27/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
