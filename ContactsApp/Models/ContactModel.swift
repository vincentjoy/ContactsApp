//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import Foundation

struct ContactModel {
    
    var id: Int
    var favorite: Bool
    var userName = ""
    var profilePictureURL: String?
    
    init?(data: [String:Any]) {
        
        guard let id = data["id"] as? Int else {
            return nil
        }
        self.id = id
        
        if let fav = data["favorite"] as? Bool {
            favorite = fav
        } else {
            favorite = false
        }
        
        if let firstName = data["first_name"] as? String {
            userName = firstName
            if let lastName = data["last_name"] as? String {
                userName += " \(lastName)"
            }
        }
    }
}
