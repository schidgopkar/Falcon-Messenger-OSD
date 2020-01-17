//
//  StatusTableViewController.swift
//  Pigeon-project
//
//  Created by Shrikant Chidgopkar on 14/01/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit

class StatusTableViewController: UITableViewController {
    
    let myStatusCellID = "myStatusCellID"
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return ""
        }else{
            return "Updates from Contacts"
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: myStatusCellID, for: indexPath) as? MyStatusTableViewCell
            else{
                return UITableViewCell()
        }
        
        cell.myStatusLabel.text = "Shrikant Chidgopkar"
        
        return cell
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyStatusTableViewCell.self, forCellReuseIdentifier: myStatusCellID)
        
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        
    }
    
    
    
    
    
    
    
}
