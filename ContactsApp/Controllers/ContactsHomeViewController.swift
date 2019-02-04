//
//  ContactsHomeViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 04/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum APIState {
    case Loading
    case Success
    case Failure
}

class ContactsHomeViewController: UIViewController {

    private var apiState = APIState.Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
