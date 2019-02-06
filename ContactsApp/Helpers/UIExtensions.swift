//
//  UIExtensions.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
    
    struct ContactsTheme {
        static let greenColor = UIColor(red: 0, green: 202, blue: 157, alpha: 1)
        static let navBarColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
}
