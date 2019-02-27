//
//  ContactsHomeViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 04/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum ViewState {
    case Loading, Success, Failure
}

class ContactsHomeViewController: UIViewController, WebserviceHandler {

    @IBOutlet var outletObject: ContactsHomeOutletObject!
    
    private var tableViewDriver: ContactsHomeTableViewDriver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        outletObject.customiseState(state: .Loading)
    }
    
    private func fetchContacts() {
        
        guard checkNetwork() else {
            outletObject.customiseState(state: .Failure)
            self.handleError(title: "No Internet", message: "Please check your connection")
            return
        }
        
        WebService.shared.request(method: .Get, url: WebServiceRoute.GetContacts(.GetContacts)) { (result) in
            switch result {
            case .Success(let data):
                if let contactsData = data as? [Dictionary<String,Any>], contactsData.count>0 {
                    self.customiseTableView(contactsData: contactsData)
                    self.outletObject.customiseState(state: .Success)
                } else {
                    self.outletObject.customiseState(state: .Failure)
                    self.handleError(message: "No data found")
                }
            case .Failure(let error):
                self.outletObject.customiseState(state: .Failure)
                self.handleError(message: error)
            }
        }
    }
    
    private func customiseTableView(contactsData: [Dictionary<String,Any>]) {
        tableViewDriver = ContactsHomeTableViewDriver(tableView: self.outletObject.tableView, parent: self)
        tableViewDriver?.reloadData(dictArray: contactsData)
    }
    
    func updateContactList(contact:ContactModel) {
        tableViewDriver?.reloadData(object: contact)
    }
}
