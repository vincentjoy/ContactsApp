//
//  ContactsHomeTableViewDriver.swift
//  ContactsApp
//
//  Created by Vincent Joy on 04/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class ContactsHomeTableViewDriver: NSObject {
    
    let tableView: UITableView
    var contacts = [ContactModel]()
    private let pendingOperations = PendingOperations()
    lazy var reuseIdentifier = "ContactCell"
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
    }
    
    func reloadData(contactsData: [Dictionary<String,Any>]) {
        for contact in contactsData {
            if let contactInstance = ContactModel(data: contact) {
                contacts.append(contactInstance)
            }
        }
        tableView.reloadData()
    }
    
    private func startDownload(for photoData: ContactModel, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
                return
        }
        
        let downloader = ImageDownloader(photoData)
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

extension ContactsHomeTableViewDriver: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (contacts.count>0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        if contacts.count < indexPath.row {
            let contact = contacts[indexPath.row]
            cell.delegate = self
            cell.configureCell(with: contact, at: indexPath.row)
        }
        
        return cell
    }
}

extension ContactsHomeTableViewDriver: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ContactsHomeTableViewDriver: ChangeFavorite {
    
    func changeFavoriteState(at index: Int) {
        
        contacts[index].changeFavorite()
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}
