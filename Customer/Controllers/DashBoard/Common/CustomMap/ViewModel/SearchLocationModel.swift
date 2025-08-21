//
//  SearchLocationModel.swift
//  MapCurrentLocation
//
//  Created by Shruti Gupta on 1/3/20.
//  Copyright © 2020 com.neosofttech.payUPayment. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation
import GoogleMaps
import GooglePlaces
class SearchLocationModel: NSObject {
    
    var nearByLocations = [Locations]()
    var searchLocations = [Locations]()
    var latLongForPlaceId : Locations?
    var currentAddress : String = ""
    
    //&language=en&
    func fetchNearByPlaces(_ lat : Double, long : Double, completionHandler:@escaping ([Locations])-> Void){
        let urlComponents = URLComponents(string: "\(GOOGLE.NEARBYSEARCH_URL)\(lat),\(long)&rankby=distance&language=en&key=\(GoogleKeys.placesKey)")!
        print("URL \(urlComponents)")
        
        //  IProgessHUD.show()
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                
                print(String(describing: response))
                print(String(describing: error))
                return
            }
            
            guard let json = try! JSONSerialization.jsonObject(with: data) as? anyDict else {
                print("not JSON format expected")
                print(String(data: data, encoding: .utf8) ?? "Not string?!?")
                return
            }
            
            guard let results = json["results"] as? [anyDict],
                let status = json["status"] as? String,
                status == "OK" else {
                    print("no results")
                    print(String(describing: json))
                    return
            }
            if self.nearByLocations.count > 0{
                self.nearByLocations.removeAll()
            }
            
            for result in results {
                
                let geoLocation = result["geometry"] as! anyDict
                let latLong = geoLocation["location"] as! anyDict
                let latitude = latLong["lat"] as! Double
                let longitude = latLong["lng"] as! Double
                
                var locationDict = anyDict()
                locationDict["latitude"] = latitude
                locationDict["longitude"] = longitude
                locationDict["name"] = result["name"] as! String
                if let desc = result["vicinity"] {
                    locationDict["vicinity"] = desc
                }
                
                
                self.nearByLocations.append(Locations(JSON: locationDict)!)
                
                
            }
            //   IProgessHUD.dismiss()
            completionHandler(self.nearByLocations)
        }
        
        task.resume()
        
    }
    func gmsAddressMapper(completionHandler:@escaping (Array<GMSPlaceLikelihood>)-> Void){
        let placesClient = GMSPlacesClient()
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                completionHandler(placeLikelihoodList)
            }
        })
    }
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(GoogleKeys.placesKey)")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as? NSDictionary  {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            var pin = ""
                            
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 6) {
                                zip =  (address.object(at: 6) as! NSDictionary)["short_name"] as! String
                            }
                            if(address.count > 9) {
                                pin =  (address.object(at: 9) as! NSDictionary)["short_name"] as! String
                            }
                            newaddress = "\(number) \(street), \(city), \(state) \(zip) \(pin)"
                            self.currentAddress = newaddress
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
        return ""
    }
    private func getParameters(for text: String, lat : String, long : String) -> [String: String] {
        let params = [
            "input": text,
            "types": "",
            "key": GoogleKeys.placesKey,
            "radius":"5000",
            //            "strictbounds":"",
            
            
            "language"  : "en",
            "location":"\(lat),\(long)"
        ]
        return params
    }
    
    func searchPlaces(_ searchText : String, lat : String, long :String, completionHandler:@escaping ([Locations])-> Void){
        
        
        let parameters = getParameters(for: searchText, lat: lat, long: long)
        
        if let encodingStr = GOOGLE.PLACES_AUTOCOMPLETE_URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            var components = URLComponents(string: encodingStr)
            components?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
            
            guard let url = components?.url else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                    print(String(describing: response))
                    print(String(describing: error))
                    return
                }
                
                guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("not JSON format expected")
                    print(String(data: data, encoding: .utf8) ?? "Not string?!?")
                    self.searchLocations.removeAll()
                    completionHandler(self.searchLocations)
                    return
                }
                
                guard let results = json["predictions"] as? [[String: Any]],
                    let status = json["status"] as? String,
                    status == "OK" else {
                        print("no results")
                        print(String(describing: json))
                        self.searchLocations.removeAll()
                        completionHandler(self.searchLocations)
                        return
                }
                self.searchLocations.removeAll()
                
                if results.count > 0 {
                    
                    for result in results{
                        
                        if let locationDetails = result["structured_formatting"] as? anyDict {
                            
                            let mainText = locationDetails["main_text"] as? String ?? ""
                            let secondaryText = locationDetails["secondary_text"] as? String ?? ""
                            let placeID = result["place_id"] as? String ?? ""
                            
                            var locationDict = anyDict()
                            //                            let geoLocation = result["geometry"] as! anyDict
                            //                            let latLong = geoLocation["location"] as! anyDict
                            //                            let latitude = latLong["lat"] as! Double
                            //                            let longitude = latLong["lng"] as! Double
                            //                            locationDict["latitude"] = latitude
                            //                            locationDict["longitude"] = longitude
                            //                            locationDict["vicinity"] = result["vicinity"] as! String
                            
                            locationDict["name"] = mainText
                            locationDict["description"] = secondaryText
                            locationDict["placeId"] = placeID
                            
                            self.searchLocations.append(Locations(JSON: locationDict)!)
                        }
                    }
                    completionHandler(self.searchLocations)
                }
                else{
                    self.searchLocations.removeAll()
                    completionHandler(self.searchLocations)
                }
            }
            task.resume()
        }
    }
    
    func fetchLatLongFromPlaceID(_ placeId : String, completionHandler:@escaping (Locations)-> Void){
        
        let urlComponents = URLComponents(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(GoogleKeys.placesKey)")!
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                print(String(describing: response))
                print(String(describing: error))
                return
            }
            
            guard let json = try! JSONSerialization.jsonObject(with: data) as? anyDict else {
                print("not JSON format expected")
                print(String(data: data, encoding: .utf8) ?? "Not string?!?")
                return
            }
            
            guard let result = json["result"] as? anyDict,
                let status = json["status"] as? String,
                status == "OK" else {
                    print("no results")
                    print(String(describing: json))
                    return
            }
            
            let geoLocation = result["geometry"] as! anyDict
            let latLong = geoLocation["location"] as! anyDict
            let latitude = latLong["lat"] as! Double
            let longitude = latLong["lng"] as! Double
            
            var locationDict = anyDict()
            locationDict["latitude"] = latitude
            locationDict["longitude"] = longitude
            self.latLongForPlaceId = Locations(JSON: locationDict)
            completionHandler(self.latLongForPlaceId!)
            
        }
        task.resume()
    }
    
    func getCountryCity(lat : Double, long : Double, completionHandler:@escaping (anyDict?)-> Void) {
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                completionHandler(nil)
                return
            }else if let country = placemarks?.first?.country,  let state = placemarks?.first?.administrativeArea,let city = placemarks?.first?.locality {
                let locationDict : anyDict = ["country":country, "state": state, "city": city]
                completionHandler(locationDict)
            }
            else {
                completionHandler(nil)
            }
        })
    }
}

