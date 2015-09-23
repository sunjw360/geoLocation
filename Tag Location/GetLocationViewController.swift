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
    @IBOutlet weak var addressLabel: UILabel!

    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var placemark: CLPlacemark?
    private var updating: Bool = false
    private var reverseGeolocationInProgress = false
    private var error: NSError?
    private var geoCoderError: NSError?
    private let geoCoder = CLGeocoder()
    
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
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        startGettingLocation()
        updateLabels()
        
    }

    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation  = locations.last
        
        print(newLocation!)
        
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
            
            getGeolocationAddress()
            
            stopGettingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        print(error)
        self.error = error
        
        updateLabels()
        stopGettingLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TagLocation" {
            let navigationVC = segue.destinationViewController as! UINavigationController
            let tagLocationVC = navigationVC.topViewController as! TagLocationTableViewController
            
            tagLocationVC.placemark = placemark
            tagLocationVC.location = location!
        }
    }
    
    //MARK: - Private Functions
    private func updateLabels() {
        if let error = error {
            statusLabel.text = "Entercountered an error."
            print("\(error)")
        } else {
            if updating {
                statusLabel.text = "Updating Location..."
            } else {
                statusLabel.text = "Ready to Update"
            }
        }
        
        if let error = geoCoderError {
            statusLabel.text = "Geocoder encountered an error."
            print("\(error)")
            if error.code == CLError.Network.rawValue {
                statusLabel.text = "Ready to Update"
                addressLabel.text = "No Network Connection"
            }
        } else {
            if let placemark = placemark {
                let subThoroughfare = (placemark.subThoroughfare == nil ? "": placemark.subThoroughfare!)
                
                let thoroughfare = (placemark.thoroughfare == nil ? "": placemark.thoroughfare!)
                
                let address = "\(subThoroughfare) \(thoroughfare) \n \(placemark.locality!), \(placemark.administrativeArea!), \(placemark.postalCode!) \n \(placemark.country!)"
                addressLabel.text = address
            } else {
                addressLabel.text = "-"
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
    
    private func getGeolocationAddress() {
        if let location = location {
            if !reverseGeolocationInProgress {
                geoCoderError = nil
                
                reverseGeolocationInProgress = true
                geoCoder.reverseGeocodeLocation(location, completionHandler: {
                    placemarks, error in
                    if error == nil && placemarks?.count > 0 {
                        self.placemark = placemarks?.last
                        self.reverseGeolocationInProgress = false
                    } else {
                        self.placemark = nil
                        self.geoCoderError = error
                    }
                    
                    self.updateLabels()
                    
                })
            }
        }
    }
}

