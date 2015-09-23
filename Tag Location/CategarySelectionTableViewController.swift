//
//  CategarySelectionTableViewController.swift
//  Tag Location
//
//  Created by Jianwei Sun on 9/22/15.
//  Copyright © 2015 EZShip. All rights reserved.
//

import UIKit

class CategarySelectionTableViewController: UITableViewController {

    var selectedCategory = ""
    var selectedIndex : NSIndexPath?
    
    let category = [
        "No Category",
        "Apple Store",
        "Bar",
        "Book Store",
        "Club",
        "Grocery Store",
        "Historic Bulding",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategaryCell")!
        
        if selectedCategory == category[indexPath.row] {
            cell.accessoryType = .Checkmark
            selectedIndex = indexPath
        }

        cell.textLabel?.text = category[indexPath.row]
        
        return cell
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let selectedCell = cell {
            selectedCell.accessoryType = .Checkmark
        }
        
        if let previousIndexPath = selectedIndex {
            tableView.cellForRowAtIndexPath(previousIndexPath)?.accessoryType = .None
        }
        
        selectedIndex = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return indexPath
    }

}
