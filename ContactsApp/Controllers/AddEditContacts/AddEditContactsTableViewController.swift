//
//  AddEditContactsTableViewController.swift
//  ContactsApp
//
//  Created by Vincent Joy on 07/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class AddEditContactsTableViewController: UITableViewController, InputAccessoryProtocol {
    
    @IBOutlet var outletObject: AddEditContactsOutletObject!

    var contact: ContactModel?
    
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
    
    @objc func doneAction() {
        print("Save contacts")
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
}

extension AddEditContactsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            outletObject.profilePicture.image = chosenImage
        }
    }
}

