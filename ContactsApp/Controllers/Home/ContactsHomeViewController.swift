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

class ContactsHomeViewController: UIViewController, WebserviceHandler {

    @IBOutlet var outletObject: ContactsHomeOutletObject!
    
    private var tableViewDriver: ContactsHomeTableViewDriver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseNavigationUI()
        customiseState(apiState: .Loading)
        fetchContacts()
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
    
    private func customiseState(apiState: APIState) {
    
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
    
    private func fetchContacts() {
        
        guard checkNetwork() else {
            self.customiseState(apiState: .Failure)
            self.handleError(title: "No Internet", message: "Please check your connection")
            return
        }
        
        WebService.shared.request(method: .Get, url: WebServiceRoute.GetContacts(.BaseURL, .GetContacts)) { (result) in
            switch result {
            case .Success(let data):
                if let contactsData = data as? [Dictionary<String,Any>] {
                    self.customiseTableView(contactsData: contactsData)
                    self.customiseState(apiState: .Success)
                }
            case .Failure(let error):
                self.customiseState(apiState: .Failure)
                self.handleError(message: error)
            }
        }
    }
    
    private func customiseTableView(contactsData: [Dictionary<String,Any>]) {
        tableViewDriver = ContactsHomeTableViewDriver(tableView: self.outletObject.tableView)
        tableViewDriver?.reloadData(contactsData: contactsData)
    }
    
    @objc func addContacts() {
        print("Show Add Contacts")
    }
    
    @objc func showGroups() {
        print("Show Groups")
    }
}
