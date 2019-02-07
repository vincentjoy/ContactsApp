//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

protocol ChangeFavourite {
    func changeFavouriteState(at indexPath: IndexPath)
}

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePictureContainer: UIImageView! {
        didSet {
            profilePictureContainer.layer.cornerRadius = profilePictureContainer.frame.width / 2
            profilePictureContainer.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: ChangeFavourite?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with contact: ContactModel, at indexPath: IndexPath) {
        
        self.userNameLabel.text = contact.userName
        self.indexPath = indexPath
        favoriteButton.isHidden = !contact.favourite
        
        if let image = contact.profilePhoto {
            self.profilePictureContainer.image = image
        } else {
            self.profilePictureContainer.image = UIImage(named: "placeholder_photo")!
        }
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        if let index = indexPath {
            self.delegate?.changeFavouriteState(at: index)
        }
    }
}
