//
//  FirstViewController.swift
//  Tag Location
//
//  Created by Jianwei Sun on 9/16/15.
//  Copyright (c) 2015 EZShip. All rights reserved.
//

import UIKit
import CoreLocation

class GetLocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var gratitudeLabel: UILabel!
    @IBOutlet weak var getLocationButton: UIButton!
    @IBOutlet weak var tagLocationButton: UIButton!

    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var updating: Bool = false
    private var error: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tagLocationButtonPressed(sender: AnyObject) {
    }
    @IBAction func getLocationButtonPressed(sender: AnyObject) {
        if !CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
        startGettingLocation()
        updateLabels()
        
    }

    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation  = locations.last as? CLLocation
        
        println(newLocation!)
        if newLocation?.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation?.horizontalAccuracy < 0 {
            return
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation!.horizontalAccuracy{
            location = newLocation
            updateLabels()
            error = nil
        }
        
        if newLocation!.horizontalAccuracy <= locationManager.desiredAccuracy {
            location = newLocation
            updateLabels()
            error = nil
            
            stopGettingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {

        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        println(error)
        self.error = error
        
        updateLabels()
        stopGettingLocation()
    }
    
    
    //MARK: - Private Functions
    private func updateLabels() {
        if let error = error {
            statusLabel.text = "Entercountered an error"
        } else {
            if updating {
                statusLabel.text = "Updating Location..."
            } else {
                statusLabel.text = "Ready to Update"
            }
        }
        
        if let location = location {
            tagLocationButton.hidden = false
            gratitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longtitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
        } else {
            gratitudeLabel.text = "-"
            longtitudeLabel.text = "-"
            tagLocationButton.hidden = true
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == CLAuthorizationStatus.Denied || authStatus == CLAuthorizationStatus.NotDetermined {
            statusLabel.text = "Location Service Not Permited"
        }
    }
    
    private func startGettingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            
            let authStatus = CLLocationManager.authorizationStatus()
            
            if authStatus == CLAuthorizationStatus.Denied || authStatus == CLAuthorizationStatus.NotDetermined {
                stopGettingLocation()
                updating = false
                error = nil
                location = nil
            } else {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
                updating = true
                tagLocationButton.hidden = true
            }
            
        } else {
        }
    }
    
    private func stopGettingLocation() {
        if updating {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        
            updating = false
            error = nil
            
            updateLabels()
        }
        
    }
}

