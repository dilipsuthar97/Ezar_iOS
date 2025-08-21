//
//  ReverseGeoCoding.swift
//  EZAR
//
//  Created by Shruti Gupta on 1/2/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import Foundation

import GooglePlaces

class ReverseGeoCoding{
    
    func getNameOfArea() {
        var placeName = ""
        let ceo: CLGeocoder = CLGeocoder()
        
         let currentLat = UserDefaults.standard.value(forKey: "currentlattitude")
         let currentLong = UserDefaults.standard.value(forKey: "currentlongitude")
       
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = currentLat as! Double
        //21.228124
        let lon: Double = currentLong as! Double
        //72.833770
        
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                    let addressString = "No location found"
                    UserDefaults.standard.set(addressString as AnyObject, forKey: "currentPlace")
                   
                }
                else{
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        // self.latitude = pm.location?.coordinate.latitude
                        // self.longitude = pm.location?.coordinate.longitude
                        // self.placeName = pm.locality!
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        print(addressString)
                        // UserDefaults.standard.set(addressString, forKey: "currentPlace")
                        // UserDefaults.standard.synchronize()
                         UserDefaults.standard.set(addressString as AnyObject, forKey: "currentPlace")
                    }
                }
        })
        
        
    }
    
}
