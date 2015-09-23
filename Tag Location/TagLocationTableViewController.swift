//
//  TagLocationTableViewController.swift
//  Tag Location
//
//  Created by Jianwei Sun on 9/21/15.
//  Copyright © 2015 EZShip. All rights reserved.
//

import UIKit
import CoreLocation

class TagLocationTableViewController: UITableViewController {
    @IBOutlet weak var descriptionTextbox: UITextView!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var location: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    private var category = "No Category"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let placemark = placemark {
            let subThoroughfare = (placemark.subThoroughfare == nil ? "": placemark.subThoroughfare!)
            
            let thoroughfare = (placemark.thoroughfare == nil ? "": placemark.thoroughfare!)
            
            let address = "\(subThoroughfare) \(thoroughfare) \n \(placemark.locality!), \(placemark.administrativeArea!), \(placemark.postalCode!) \n \(placemark.country!)"
            
            addressLabel.text = address
            
        }else {
            addressLabel.text = "Address Not Available"
        }
        
        longtitudeLabel.text = "\(location.coordinate.longitude)"
        latitudeLabel.text = "\(location.coordinate.latitude)"
        categoryLabel.text = category
        
        let gestureRec = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        gestureRec.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRec)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Category" {
            let categorySelectionVC = segue.destinationViewController as! CategarySelectionTableViewController
            
            categorySelectionVC.selectedCategory = category
        }
    }
    
    @IBAction func categorySelectionMade(segue: UIStoryboardSegue) {
        
        let categorySelectionVC = segue.sourceViewController as! CategarySelectionTableViewController
        
        category = categorySelectionVC.category[categorySelectionVC.selectedIndex!.row]
        categoryLabel.text = category
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideKeyboard(gestureRc: UIGestureRecognizer) {
        let touchPoint = gestureRc.locationInView(tableView)
        
        let indexPath = tableView.indexPathForRowAtPoint(touchPoint)
        
        if indexPath != nil && indexPath!.row == 0 && indexPath!.section == 0 {
            return
        }
        
        descriptionTextbox.resignFirstResponder()
    }

}
