//
//  ContactDetailsTableViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var outletObject: ContactDetailsOutletObject!
    
    var contact: ContactModel?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        if let contact = contact {
            outletObject.setUI(with: contact)
        }
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        
        if let mobile = contact?.phoneNumber, !mobile.isEmpty {
            
            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                controller.body = ""
                controller.recipients = [mobile]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editContact() {
        (self.navigationController as? MainNavigationController)?.showAddOrEditContacts(for: true)
    }
}
