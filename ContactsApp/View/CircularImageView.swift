//
//  CircularImageView.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
    }
}
