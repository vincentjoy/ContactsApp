//
//  AddEditContactsTableViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class AddEditContactsTableViewController: UITableViewController {

    var editContacts = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func doneAction() {
        print("Save contacts")
    }
    
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
