//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum ProfilePhotoState {
    /* To represent the status of the image download operation in the queue */
    case New, Downloaded, Failed
}

class ContactModel {
    
    var id: Int
    var favourite = false
    var firstName = ""
    var lastName = ""
    var userName = ""
    var phoneNumber: String?
    var email: String?
    var profilePhotoURL: String?
    var profilePhotoState = ProfilePhotoState.New
    var profilePhoto: UIImage? /* Image will be added only after the state changes to .downloaded */
    
    init?(data: [String:Any]) {
        
        guard let id = data["id"] as? Int else {
            return nil
        }
        self.id = id
        
        if let favourite = data["favorite"] as? Bool {
            self.favourite = favourite
        }
        
        updateNameDetails(data: data)
        
        if let profilePic = data["profile_pic"] as? String, !profilePic.contains("/images/missing.png") {
            self.profilePhotoURL = profilePic
        }
    }
    
    func changeFavourite() {
        favourite = !favourite
    }
    
    func updateDetails(data: [String:Any]) {
        
        if let phoneNumber = data["phone_number"] as? String {
            self.phoneNumber = phoneNumber
        }
        
        if let email = data["email"] as? String {
            self.email = email
        }
        
        updateNameDetails(data: data)
    }
    
    private func updateNameDetails(data: [String:Any]) {
        
        if let FName = data["first_name"] as? String {
            userName = FName
            firstName = FName
            if let LName = data["last_name"] as? String {
                userName += " \(lastName)"
                lastName = LName
            }
        }
    }
}
