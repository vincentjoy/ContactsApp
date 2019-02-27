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

    private var activeField = 0
    private var detailsChanged = false
    var contact: ContactModel? /* If contact is not nil, that means this view controller is for editing details */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        for (index, tf) in outletObject.fieldEntry.enumerated() {
            tf.delegate = self
            tf.tag = index
            tf.inputAccessoryView = createInputAccessoryView(lastField: (index==(outletObject.fieldEntry.count-1)))
        }
        
        if let contact = contact {
            outletObject.setupUIForEdit(contact: contact)
        }
        
        outletObject.fieldEntry[ProfileTextField.FName.rawValue].becomeFirstResponder()
    }
    
    @objc func doneTouched() {
        outletObject.fieldEntry[activeField].resignFirstResponder()
    }
    
    @objc func showNext() {
        outletObject.fieldEntry[activeField+1].becomeFirstResponder()
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
        
        var url = WebServiceRoute.GetContacts(.GetContacts)
        var method = HTTPMethod.Post
        if let contact = contact {
            url = WebServiceRoute.ContactOperations(.ContactOperations, "\(contact.id)")
            method = HTTPMethod.Put
            dataDictionary["favorite"] = contact.favourite
        }
        
        WebService.shared.request(method: method, url: url, parameters: dataDictionary) { (result) in
            print("Response is \n\(result)")
            switch result {
            case .Success(let data):
                if let contactsData = data as? [String:Any], let instance = ContactModel(data: contactsData) {
                    if let _ = self.contact {
                        
                        /* Means, this is an editing contact process and therefore should update the details in Edit screen. Since ContactModel is a class and it is passed by reference, editing the self.contact will change the ContactModel instance value in the edit screen also */
                        
                        self.contact?.updateDetails(data: contactsData)
                        self.delegate?.contactUpdate(with: nil)
                        
                    } else {
                        /* Means, this is a new contact and should add to the contact list in home screen */
                        self.delegate?.contactUpdate(with: instance)
                    }
                } else if let errorsData = data as? [String:Any],
                    let errors = errorsData["errors"] as? [String] {
                    self.handleError(title: "Operation failed", message: errors.joined(separator: ", "))
                } else {
                    self.handleError(message: "Contact operation failed")
                }
            case .Failure(let error):
                self.handleError(message: error)
            }
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField.tag
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == ProfileTextField.Email.rawValue {
            textField.resignFirstResponder()
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

