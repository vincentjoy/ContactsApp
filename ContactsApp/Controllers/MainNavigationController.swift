//
//  MainNavigationController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    var reloadIndex: IndexPath? { /* To update contact list cell if any contact changed to favorite from Contact Details */
        didSet {
            let tableView = (self.children.first as? ContactsHomeViewController)?.outletObject.tableView
            tableView?.beginUpdates()
            tableView?.reloadRows(at: [reloadIndex!], with: .none)
            tableView?.endUpdates()
        }
    }
    private lazy var ContactDetailsIdentifier = "ContactDetailsTVC"
    private lazy var AddEditContactsIdentifier = "AddEditContactsTVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupInitialUI()
    }
    
    private func setupInitialUI() {
        
        self.navigationBar.tintColor = UIColor.ContactsTheme.greenColor
        
        if let firstVC = self.viewControllers.first as? ContactsHomeViewController {
            
            firstVC.title = "Contact"
            
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addContacts))
            firstVC.navigationItem.rightBarButtonItem = add
            
            let groups = UIBarButtonItem.init(title: "Groups", style: .plain, target: self, action: #selector(self.showGroups))
            firstVC.navigationItem.leftBarButtonItem = groups
        }
    }
    
    @objc func addContacts() {
        showAddOrEditContacts(with: nil)
    }
    
    @objc func showGroups() {
        print("Show Groups")
    }
    
    func showAddOrEditContacts(with data: ContactModel?) {
        
        /* If the ContactModel instance is not nil, that means we need to show Edit Contact Screen, not Add Contact. We are using same view controller for both */
        
        if let addContactsVC = self.storyboard?.instantiateViewController(withIdentifier: AddEditContactsIdentifier) as? AddEditContactsTableViewController {
            
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: addContactsVC, action: #selector(addContactsVC.saveContact))
            addContactsVC.navigationItem.rightBarButtonItem = done
            
            let cancel = UIBarButtonItem.init(title: "Cancel", style: .plain, target: addContactsVC, action: #selector(addContactsVC.cancelAction))
            addContactsVC.navigationItem.leftBarButtonItem = cancel
            
            addContactsVC.delegate = self
            addContactsVC.contact = data
            
            self.pushViewController(addContactsVC, animated: true)
        }
    }
    
    func showContactDetails(for contact: ContactModel, at index: IndexPath) {
        
        if let contactDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: ContactDetailsIdentifier) as? ContactDetailsTableViewController {
            
            let edit = UIBarButtonItem.init(title: "Edit", style: .plain, target: contactDetailsVC, action: #selector(contactDetailsVC.editContact))
            contactDetailsVC.navigationItem.rightBarButtonItem = edit
            
            contactDetailsVC.selectedIndex = index
            contactDetailsVC.contact = contact
            
            self.pushViewController(contactDetailsVC, animated: true)
        }
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController.isKind(of: ContactsHomeViewController.self) {
            navigationBar.shadowImage = nil
        } else {
            navigationBar.shadowImage = UIImage()
        }
        navigationBar.layoutIfNeeded()
    }
}

extension MainNavigationController: AddEditProtocol {
    
    func contactUpdate(with newContact: ContactModel?) {
        
        /* If contact is edited, we need to show that new details in contact details screen. Because popViewController will land in the Contact Details screen */
        /* If it was an addition of new contact, view controller will pop to contact list and add this new contact in the list and reload the table view */
        
        for vc in viewControllers {
            
            if let contactInstance = newContact, let homeVC = vc as? ContactsHomeViewController {
                homeVC.updateContactList(contact: contactInstance)
            } else if let detailsVC = vc as? ContactDetailsTableViewController {
                detailsVC.setupUI(fromDelegate: true)
            }
        }
        
        popViewController(animated: true)
    }
}
