//
//  PhotoOperations.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class PendingOperations {
    
    /* This class contains a dictionary to keep track of active and pending download operations for each cell in the table view, and a corresponding operation queue. */
    
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        return queue
    }()
}

class ImageDownloader: Operation {
    
    /* This class is using to track the status of each operation */
    
    let photoObject: ContactModel
    
    init(_ photoObject: ContactModel) {
        self.photoObject = photoObject
    }
    
    override func main() {
        
        if isCancelled {
            
            /* Check for cancellation before starting. Operations should regularly check if they have been cancelled before attempting long or intensive work. */
            
            return
        }
        
        guard let profilePhotoURL = photoObject.profilePhotoURL,
            let url = URL(string: profilePhotoURL),
            let imageData = try? Data(contentsOf: url)
        else {
            photoObject.profilePhotoState = .Failed
            photoObject.profilePhoto = nil
            return
        }
        
        if isCancelled {
            return
        }
        
        /* If there is data, create an image object and add it to the record, and move the state along. If there is no data, mark the record as failed. */
        
        if !imageData.isEmpty {
            photoObject.profilePhoto = UIImage(data:imageData)
            photoObject.profilePhotoState = .Downloaded
        } else {
            photoObject.profilePhotoState = .Failed
            photoObject.profilePhoto = nil
        }
    }
}
