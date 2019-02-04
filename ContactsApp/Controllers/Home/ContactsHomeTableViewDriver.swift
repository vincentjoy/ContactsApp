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
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension ContactsHomeTableViewDriver: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ContactsHomeTableViewDriver: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
