//
//  ContactsHomeOutletObject.swift
//  ContactsApp
//
//  Created by Vincent Joy on 04/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class ContactsHomeOutletObject: NSObject {
    
    /* This class can be used to put all the IBOutlets in one place. If this is a big view controller with lots of outlets, then this separate class can help us to reduce the code size in view controller */
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var indicatorContainer: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    func customiseState(state: ViewState) {
        
        switch state {
        case .Loading:
            tableView.isHidden = true
            indicatorContainer.isHidden = false
            indicatorLabel.text = "Loading contacts"
            activityIndicator.startAnimating()
        case .Success:
            tableView.isHidden = false
            indicatorContainer.isHidden = true
            activityIndicator.stopAnimating()
        case .Failure:
            tableView.isHidden = true
            indicatorContainer.isHidden = false
            activityIndicator.stopAnimating()
            indicatorLabel.text = "No contacts found!"
        }
    }
}
