//
//  ContactDetailsTableViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailsTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, WebserviceHandler {
    
    @IBOutlet var outletObject: ContactDetailsOutletObject!
    
    var contact: ContactModel?
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        setupUI(fromDelegate: false)
    }
    
    func setupUI(fromDelegate: Bool) {
        
        /* If fromDelegate is true, it means this method is called after the editing of contact. So we need to update the new details in this screen */
        
        if let contact = contact {
            
            outletObject.initialiseUI(with: contact)
            
            if !fromDelegate {
                updateUI(contact: contact)
            }
        }
    }
    
    private func updateUI(contact: ContactModel) {
        
        guard checkNetwork() else {
            self.handleError(title: "No Internet", message: "Please check your connection")
            return
        }
        
        WebService.shared.request(method: .Get, url: WebServiceRoute.ContactOperations(.BaseURL, .ContactOperations, "\(contact.id)")) { (result) in
            switch result {
            case .Success(let data):
                if let contactsData = data as? [String:Any] {
                    contact.updateDetails(data: contactsData) /* Update the lastName, email and phoneNumber */
                    self.outletObject.initialiseUI(with: contact)
                } else {
                    self.handleError(message: "No data found")
                }
            case .Failure(let error):
                self.handleError(message: error)
            }
        }
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        
        if let mobile = contact?.phoneNumber {
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
        
        guard let mobile = contact?.phoneNumber,
            let url = URL(string: "tel://\(mobile)"),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        
        guard MFMailComposeViewController.canSendMail(), let email = contact?.email else {
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([email])
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func favouriteAction(_ sender: UIButton) {
        
        if let contact = contact {
            
            contact.changeFavourite() /* Since ContactModel is a class and it is passed by reference, editing the self.contact will change the ContactModel instance value in the other screens also since all the screens are sharing the same instance of ContactModel */
            
            let favImage = contact.favourite ? UIImage(named: "favourite_button_selected")! : UIImage(named: "favourite_button")!
            outletObject.favouriteButton.setImage(favImage, for: .normal)
            
            /* Since this contact is favourited, we need to show the favourite image in the contacts list page. So setting "reloadIndex" will reload the table view */
            (self.navigationController as? MainNavigationController)?.reloadIndex = selectedIndex
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editContact() {
        (self.navigationController as? MainNavigationController)?.showAddOrEditContacts(with: contact)
    }
}
