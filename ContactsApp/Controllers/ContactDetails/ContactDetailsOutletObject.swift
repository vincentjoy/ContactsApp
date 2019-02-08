//
//  ContactDetailsOutletObject.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class ContactDetailsOutletObject: NSObject {
    
    /* This class can be used to put all the IBOutlets in one place. If this is a big view controller with lots of outlets, then this separate class can help us to reduce the code size in view controller */

    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = UIColor.ContactsTheme.navBarColor
        }
    }
    @IBOutlet weak var profilePicture: CircularImageView!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    
    func initialiseUI(with contact: ContactModel) {
        
        mobile.text = contact.phoneNumber ?? ""
        email.text = contact.email ?? ""
        userName.text = contact.userName
        
        if let img = contact.profilePhoto {
            profilePicture.image = img
        } else if let profilePhotoURL = contact.profilePhotoURL,
            let url = URL(string: profilePhotoURL) {
            
            DispatchQueue.global(qos: .default).async {
                
                if let imageData = try? Data(contentsOf: url),
                    !imageData.isEmpty,
                    let img = UIImage(data:imageData) {
                    
                    DispatchQueue.main.async {
                        self.profilePicture.image = img
                    }
                }
            }
        }
        
        smsButton.isEnabled = (contact.phoneNumber != nil)
        smsButton.alpha = (contact.phoneNumber != nil) ? 0.7 : 1.0
        callButton.isEnabled = (contact.phoneNumber != nil)
        callButton.alpha = (contact.phoneNumber != nil) ? 0.7 : 1.0
        
        emailButton.isEnabled = (contact.email != nil)
        emailButton.alpha = (contact.email != nil) ? 0.7 : 1.0
        
        let favImage = contact.favourite ? UIImage(named: "favourite_button_selected")! : UIImage(named: "favourite_button")!
        favouriteButton.setImage(favImage, for: .normal)
    }
}
