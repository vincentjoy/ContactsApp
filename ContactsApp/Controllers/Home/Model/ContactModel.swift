//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum ProfilePhotoState {
    case New, Downloaded, Failed
}

class ContactModel {
    
    var id: Int
    var favorite: Bool?
    var userName = ""
    var profilePhotoURL: String?
    var profilePhotoState = ProfilePhotoState.New
    var profilePhoto: UIImage?
    
    init?(data: [String:Any]) {
        
        guard let id = data["id"] as? Int else {
            return nil
        }
        self.id = id
        
        if let favorite = data["favorite"] as? Bool, favorite {
            self.favorite = favorite
        }
        
        if let firstName = data["first_name"] as? String {
            userName = firstName
            if let lastName = data["last_name"] as? String {
                userName += " \(lastName)"
            }
        }
        
        if let profilePic = data["profile_pic"] as? String, !profilePic.contains("/images/missing.png") {
            self.profilePhotoURL = profilePic
        }
    }
    
    func changeFavorite() {
        if let favorite = self.favorite {
            self.favorite = !favorite
        }
    }
}
