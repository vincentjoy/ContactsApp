//
//  PhotoOperations.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

class PendingOperations {
    
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        return queue
    }()
}

class ImageDownloader: Operation {
    
    let photoObject: ContactModel
    
    init(_ photoObject: ContactModel) {
        self.photoObject = photoObject
    }
    
    override func main() {
        
        if isCancelled {
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
        
        if !imageData.isEmpty {
            photoObject.profilePhoto = UIImage(data:imageData)
            photoObject.profilePhotoState = .Downloaded
        } else {
            photoObject.profilePhotoState = .Failed
            photoObject.profilePhoto = nil
        }
    }
}
