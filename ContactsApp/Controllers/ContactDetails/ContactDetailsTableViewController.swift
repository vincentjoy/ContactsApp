//
//  ContactDetailsTableViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class ContactDetailsTableViewController: UITableViewController {
    
    @IBOutlet var outletObject: ContactDetailsOutletObject!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        
    }
    
    @objc func editContact() {
        (self.navigationController as? MainNavigationController)?.showAddOrEditContacts(for: true)
    }
}
