//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

protocol ChangeFavorite {
    func changeFavoriteState(at index:Int)
}

class ContactTableViewCell: UITableViewCell {
    
    var delegate: ChangeFavorite?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with contact: ContactModel, at index: Int) {
        
        self.textLabel?.text = contact.userName
        if let favorite = contact.favorite {
            
            let button = UIButton(type: .custom)
            
            let favImage = favorite ? UIImage(named: "favourite_button_selected")! : UIImage(named: "favourite_button")!
            button.setImage(favImage, for: .normal)
            
            button.addTarget(self, action: #selector(self.favorited(sender:)), for: .touchUpInside)
            button.tag = index
            button.sizeToFit()
            self.accessoryView = button
            
        } else {
            self.accessoryView = UIView()
        }
    }
    
    @objc func favorited(sender: UIButton) {
        self.delegate?.changeFavoriteState(at: sender.tag)
    }
}
