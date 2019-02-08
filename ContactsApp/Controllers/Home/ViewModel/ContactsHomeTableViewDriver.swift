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
    private let imageCache = NSCache<NSString, UIImage>()
    private var reuseIdentifier = "ContactCell"
    
    weak var parent: ContactsHomeViewController?
    
    init(tableView: UITableView, parent: ContactsHomeViewController) {
        
        self.tableView = tableView
        super.init()
        
        self.parent = parent
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.sectionIndexColor = UIColor.ContactsTheme.greenColor
        imageCache.countLimit = 30
    }
    
    func reloadData(dictArray: [Dictionary<String,Any>]) {
        
        /* This method is called when the data is fetched from initla API call */
        
        var contacts = [ContactModel]()
        for contact in dictArray {
            if let contactInstance = ContactModel(data: contact) {
                contacts.append(contactInstance)
            }
        }
        reloadData(objectArray: contacts)
    }
    
    func reloadData(object: ContactModel) {
        /* This method is called when a new contact is created and we need to show that contact in the contact list */
        
        var contacts = groupedContacts.flatMap{$0}
        contacts.append(object)
        
        reloadData(objectArray: contacts)
    }
    
    private func reloadData(objectArray: [ContactModel]) {
        
        /* Create a group of ContactModel instance array, in accordance to the alpahabetic order */
        
        let contacts = objectArray.sorted(by: { $0.userName.uppercased() < $1.userName.uppercased() })
        
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
            
            /* If the contact object's profilePhotoState is .new, we kick off a start download operation of image and if it is fail, we will change the UI of the cell accordingly. And if the state is already downloaded, in the configureCellWith(contact:) of ContactTableViewCell, the cell will receive the downloaded image */
            
            if contact.profilePhotoState == .New {
                startDownload(for: contact, at: indexPath)
            }
        }
        
        return cell
    }
    
    private func startDownload(for photoData: ContactModel, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil, let urlString = photoData.profilePhotoURL else {
            
            /* Checking for this particular indexPath, whether there is already an operation in downloadsInProgress or not. If so, ignore this request. */
            
            return
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            
            /* Checking whether image is available in the cache. If yes, we will load from there only instead of going for the download process again. */
            
            photoData.profilePhoto = cachedImage
            self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
            if (self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        } else {
            
            let downloader = ImageDownloader(photoData)
            downloader.completionBlock = {
                if downloader.isCancelled {
                    return
                }
                
                /* This completion block will be executed when the operation is completed. The completion block is executed even if the operation is cancelled, so we must check this property before doing anything. We also have no guarantee of which thread the completion block is called on, so using a GCD to trigger a reload of the table view on the main thread. */
                
                DispatchQueue.main.async {
                    self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                    if (self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                    if let downloadedImage = downloader.photoObject.profilePhoto {
                        self.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    }
                }
            }
            
            /* Creating the operation to downloadsInProgress to help keep track of things. and adding the operation to the download queue. So we will trigger these operations to start running. */
            
            pendingOperations.downloadsInProgress[indexPath] = downloader
            pendingOperations.downloadQueue.addOperation(downloader)
        }
    }
}

extension ContactsHomeTableViewDriver: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if indexPath.row < groupedContacts[indexPath.section].count {
                let contact = groupedContacts[indexPath.section][indexPath.row]
                if contact.profilePhotoState == .New {
                    startDownload(for: contact, at: indexPath)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if (indexPath.row < groupedContacts[indexPath.section].count) && (pendingOperations.downloadsInProgress[indexPath] != nil) {
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
        }
    }
}

extension ContactsHomeTableViewDriver: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = groupedContacts[indexPath.section][indexPath.row]
        (self.parent?.navigationController as? MainNavigationController)?.showContactDetails(for: contact, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        view.backgroundColor = UIColor.groupTableViewBackground
        
        let label = UILabel.init(frame: CGRect(x: 16, y: 4, width: (UIScreen.main.bounds.size.width - 32), height: 20))
        label.text = "\(groupedContacts[section].first!.userName.first!)".uppercased()
        
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

extension ContactsHomeTableViewDriver: ChangeFavourite {
    
    func changeFavouriteState(at indexPath: IndexPath) {
        
        groupedContacts[indexPath.section][indexPath.row].changeFavourite()
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}
