//
//  AddEditContactsOutletObject.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum ProfileTextField: Int {
    
    case FName, LName, Mobile, Email
    
    var keyName: String {
        switch self {
        case .FName:
            return "first_name"
        case .LName:
            return "last_name"
        case .Mobile:
            return "phone_number"
        case .Email:
            return "email"
        }
    }
}

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
    @IBOutlet var fieldEntry: [UITextField]!
    
    func setupUIForEdit(contact: ContactModel) {
        
        for tf in fieldEntry {
            if tf.tag==ProfileTextField.FName.rawValue {
                tf.text = contact.firstName
            } else if tf.tag==ProfileTextField.LName.rawValue {
                tf.text = contact.lastName
            } else if tf.tag==ProfileTextField.Mobile.rawValue {
                tf.text = contact.phoneNumber ?? ""
            } else if tf.tag==ProfileTextField.Email.rawValue {
                tf.text = contact.email ?? ""
            }
        }
    }
}
