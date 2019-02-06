//
//  ContactDetailsOutletObject.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class ContactDetailsOutletObject: NSObject {

    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = UIColor.ContactsTheme.navBarColor
        }
    }
    @IBOutlet weak var profilePicture: UIImageView! {
        didSet {
            profilePicture.layer.cornerRadius = profilePicture.bounds.width/2
            profilePicture.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
}
