//
//  LocationGetter.swift
//  Swish
//
//  Created by webwerks on 06/09/16.
//  Copyright © 2016 Talk Agency. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationGetterDelegate: class {
    func didUpdateLocation(_ sender: CLLocation)
}

class LocationGetter: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    weak var delegate: LocationGetterDelegate?
  
    class var sharedInstance : LocationGetter {
        struct Static {
            static let instance : LocationGetter = LocationGetter()
        }
        return Static.instance
    }
    
    func initLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation(){
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationManger() {
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if delegate != nil {
            if let location = locations.first {
                delegate?.didUpdateLocation(location)
            }            
        }
    }
        
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // comapring Authorization Status and perfrom operation accordingly
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            let title: String = (status == .denied) ? "Location services are disabled" : "Background location is not enabled";
            let message: String = "To re-enable, please go to Settings and turn on Location Service for this app.";
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alertController.addAction( UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
            alertController.addAction( UIAlertAction(title: "Settings", style: .default, handler:{(action:UIAlertAction) in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    //open setting application if location is disabled
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsURL, options: [:])
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }))
            
            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            break
        }
    }
}
