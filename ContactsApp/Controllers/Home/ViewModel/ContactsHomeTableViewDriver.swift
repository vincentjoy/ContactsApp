//
//  ContactsHomeTableViewDriver.swift
//  ContactsApp
//
//  Created by Vincent Joy on 04/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class ContactsHomeTableViewDriver: NSObject {
    
    private let tableView: UITableView
    private var groupedContacts = [[ContactModel]]()
    private let pendingOperations = PendingOperations()
    private var alphabets = [String]()
    
    weak var parent: ContactsHomeViewController?
    lazy var reuseIdentifier = "ContactCell"
    
    init(tableView: UITableView, parent: ContactsHomeViewController) {
        
        self.tableView = tableView
        super.init()
        
        self.parent = parent
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexColor = UIColor.ContactsTheme.greenColor
    }
    
    func reloadData(contactsData: [Dictionary<String,Any>]) {
        
        var contacts = [ContactModel]()
        for contact in contactsData {
            if let contactInstance = ContactModel(data: contact) {
                contacts.append(contactInstance)
            }
        }
        contacts = contacts.sorted(by: { $0.userName.uppercased() < $1.userName.uppercased() })
        
        groupedContacts = contacts.reduce([[ContactModel]]()) {
            
            guard var last = $0.last else {
                return [[$1]]
            }
            
            var collection = $0
            if last.first!.userName.uppercased().first == $1.userName.uppercased().first {
                last += [$1]
                collection[collection.count - 1] = last
            } else {
                alphabets.append("\(last.first!.userName.first!)".uppercased())
                collection += [[$1]]
            }
            return collection
        }
        
        tableView.reloadData()
    }
}

extension ContactsHomeTableViewDriver: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (groupedContacts.count>0 ? groupedContacts.count : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedContacts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row < groupedContacts[indexPath.section].count {
            
            let contact = groupedContacts[indexPath.section][indexPath.row]
            cell.delegate = self
            cell.configureCell(with: contact, at: indexPath)
            
            if contact.profilePhotoState == .New {
                startDownload(for: contact, at: indexPath)
            }
        }
        
        return cell
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
                self.tableView.reloadData()
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

extension ContactsHomeTableViewDriver: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = groupedContacts[indexPath.section][indexPath.row]
        (self.parent?.navigationController as? MainNavigationController)?.showContactDetails(for: contact)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        view.backgroundColor = UIColor.groupTableViewBackground
        
        let label = UILabel.init(frame: CGRect(x: 16, y: 4, width: (UIScreen.main.bounds.size.width - 32), height: 20))
        label.text = "\(groupedContacts[section].first!.userName.first!)"
        
        view.addSubview(label)
        return view
    }
    
    @objc(sectionIndexTitlesForTableView:) func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return alphabets
    }
    
    @objc(tableView:sectionForSectionIndexTitle:atIndex:) func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return (alphabets.firstIndex(of: title) ?? 0)
    }
}

extension ContactsHomeTableViewDriver: ChangeFavorite {
    
    func changeFavoriteState(at indexPath: IndexPath) {
        
        groupedContacts[indexPath.section][indexPath.row].changeFavorite()
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}
