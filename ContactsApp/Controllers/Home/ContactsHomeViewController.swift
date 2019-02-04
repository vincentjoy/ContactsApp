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

    @IBOutlet var outletObject: ContactsHomeOutletObject!
    
    private var apiState = APIState.Loading
    private var tableViewDriver: ContactsHomeTableViewDriver?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        customiseState()
        customiseNavigationUI()
        customiseTableView()
    }
    
    private func customiseNavigationUI() {
        
        self.title = "Contact"
    
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addContacts))
        self.navigationItem.rightBarButtonItem = add
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.ContactsTheme.greenColor
        
        let groups = UIBarButtonItem.init(title: "Groups", style: .plain, target: self, action: #selector(self.addContacts))
        self.navigationItem.leftBarButtonItem = groups
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.ContactsTheme.greenColor
    }
    
    private func customiseState() {
    
        switch apiState {
        case .Loading:
            outletObject.tableView.isHidden = true
            outletObject.indicatorContainer.isHidden = false
            outletObject.indicatorLabel.text = "Loading contacts"
            outletObject.activityIndicator.startAnimating()
        case .Success:
            outletObject.tableView.isHidden = false
            outletObject.indicatorContainer.isHidden = true
            outletObject.activityIndicator.stopAnimating()
        case .Failure:
            outletObject.tableView.isHidden = true
            outletObject.indicatorContainer.isHidden = false
            outletObject.activityIndicator.stopAnimating()
            outletObject.indicatorLabel.text = "No contacts found!"
        }
    }
    
    private func customiseTableView() {
        tableViewDriver = ContactsHomeTableViewDriver(tableView: self.outletObject.tableView)
        tableViewDriver?.reloadData()
    }
    
    @objc func addContacts() {
        print("Show Add Contacts")
    }
    
    @objc func showGroups() {
        print("Show Groups")
    }
}
