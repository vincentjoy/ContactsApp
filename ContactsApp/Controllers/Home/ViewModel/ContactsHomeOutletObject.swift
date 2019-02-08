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
}
