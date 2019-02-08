//
//  AddEditContactsTableViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

protocol AddEditProtocol: class {
    func contactUpdate(with newContact: ContactModel?)
}

class AddEditContactsTableViewController: UITableViewController, InputAccessoryProtocol, WebserviceHandler {
    
    @IBOutlet var outletObject: AddEditContactsOutletObject!
    
    weak var delegate: AddEditProtocol?

    private var detailsChanged = false
    var contact: ContactModel? /* If contact is not nil, that means this view controller is for editting details */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        for (index, tf) in outletObject.fieldEntry.enumerated() {
            tf.delegate = self
            tf.tag = index
            tf.inputAccessoryView = createInputAccessoryView()
        }
        
        if let contact = contact {
            outletObject.setupUIForEdit(contact: contact)
        }
        
        outletObject.fieldEntry[ProfileTextField.FName.rawValue].becomeFirstResponder()
    }
    
    @objc func doneTouched() {
        tableView.endEditing(true)
    }
    
    @objc func saveContact() {
        
        tableView.endEditing(true)
        
        guard detailsChanged else { /* If there is anything edited, then only need to call the API */
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard checkNetwork() else {
            self.handleError(title: "No Internet", message: "Please check your connection")
            return
        }
        
        var dataDictionary = [String:Any]()
        for tf in outletObject.fieldEntry {
            if let txt = tf.text, txt.count>0, let key = ProfileTextField(rawValue: tf.tag)?.keyName {
                dataDictionary[key] = txt
            }
        }
        
        guard !dataDictionary.isEmpty else {
            self.handleError(message: "No details to save")
            return
        }
        
        dataDictionary["favorite"] = false
        
        var url = WebServiceRoute.GetContacts(.BaseURL, .GetContacts)
        var method = HTTPMethod.Post
        if let contact = contact {
            url = WebServiceRoute.ContactOperations(.BaseURL, .ContactOperations, "\(contact.id)")
            method = HTTPMethod.Put
            dataDictionary["favorite"] = contact.favourite
            
            self.contact?.updateDetails(data: dataDictionary)
            self.delegate?.contactUpdate(with: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        /*
        let parameters = ["mode": "raw", "raw": dataDictionary.description]
        WebService.shared.request(method: method, url: url, parameters: dataDictionary) { (result) in
            switch result {
            case .Success(let data):
                print(data)
                if let contactsData = data as? [String:Any], let instance = ContactModel(data: contactsData) {
                    if let _ = self.contact {
                        self.contact?.updateDetails(data: contactsData)
                        self.delegate?.contactUpdate(with: nil)
                    } else {
                        self.delegate?.contactUpdate(with: instance)
                    }
                } else {
                    self.handleError(message: "Contact saving failed")
                }
            case .Failure(_):
                self.handleError(message: "Contact saving failed")
            }
        }
        */
    }
    
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Select an image from", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                self.present(myPickerController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.present(myPickerController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension AddEditContactsTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == ProfileTextField.Email.rawValue {
            tableView.endEditing(true)
        } else {
            outletObject.fieldEntry[textField.tag+1].becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        detailsChanged = true /* Setting that details has changed. So clicking Done button should call API */
        return true
    }
}

extension AddEditContactsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            outletObject.profilePicture.image = chosenImage
        }
    }
}

