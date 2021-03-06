//
//  CustomMethods.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit
import SystemConfiguration

protocol WebserviceHandler: class {
    func checkNetwork() -> Bool
    func handleError(title: String?, message: String)
}

protocol InputAccessoryProtocol: class {
    func createInputAccessoryView(lastField: Bool) -> UIToolbar
}

extension WebserviceHandler where Self: UIViewController {
    
    func checkNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func handleError(title: String? = nil, message: String) {
        
        let alert = UIAlertController(title: (title ?? "Sorry"), message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion:nil)
    }
}

extension InputAccessoryProtocol where Self: UIViewController {
    
    func createInputAccessoryView(lastField: Bool) -> UIToolbar {
        
        let toolbarAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        toolbarAccessoryView.barStyle = .default
        toolbarAccessoryView.tintColor = UIColor.ContactsTheme.greenColor
        let flexSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target:nil, action:nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:.done, target:self, action:Selector(("doneTouched")))
        
        if lastField {
            toolbarAccessoryView.setItems([flexSpace, doneButton], animated: false)
        } else {
            let nextButton = UIBarButtonItem.init(title: "Next", style: .done, target: self, action: Selector(("showNext")))
            toolbarAccessoryView.setItems([nextButton, flexSpace, doneButton], animated: false)
        }
        
        return toolbarAccessoryView
    }
    
}
