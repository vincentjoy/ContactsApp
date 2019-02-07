//
//  MainNavigationController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    var reloadHomeTableView = false
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
        showAddOrEditContacts(for: false)
    }
    
    @objc func showGroups() {
        print("Show Groups")
    }
    
    func showAddOrEditContacts(for edit: Bool) {
        
        if let addContactsVC = self.storyboard?.instantiateViewController(withIdentifier: AddEditContactsIdentifier) as? AddEditContactsTableViewController {
            
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: addContactsVC, action: #selector(addContactsVC.doneAction))
            addContactsVC.navigationItem.rightBarButtonItem = done
            
            let cancel = UIBarButtonItem.init(title: "Cancel", style: .plain, target: addContactsVC, action: #selector(addContactsVC.cancelAction))
            addContactsVC.navigationItem.leftBarButtonItem = cancel
            
            addContactsVC.editContacts = edit
            self.pushViewController(addContactsVC, animated: true)
        }
    }
    
    func showContactDetails(for contact: ContactModel) {
        
        if let contactDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: ContactDetailsIdentifier) as? ContactDetailsTableViewController {
            
            let edit = UIBarButtonItem.init(title: "Edit", style: .plain, target: contactDetailsVC, action: #selector(contactDetailsVC.editContact))
            contactDetailsVC.navigationItem.rightBarButtonItem = edit
            
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
        
        if viewController.isKind(of: ContactsHomeViewController.self) && reloadHomeTableView {
            (viewController as? ContactsHomeViewController)?.outletObject.tableView.reloadData()
            reloadHomeTableView = !reloadHomeTableView
        }
    }
}
