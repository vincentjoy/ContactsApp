//
//  AddEditContactsOutletObject.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class AddEditContactsOutletObject: NSObject {

    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = UIColor.ContactsTheme.navBarColor
        }
    }
    @IBOutlet weak var profilePicture: CircularImageView!
    @IBOutlet weak var cameraButton: UIButton! {
        didSet {
            cameraButton.layer.cornerRadius = cameraButton.bounds.width/2
            cameraButton.layer.masksToBounds = true
        }
    }
}
