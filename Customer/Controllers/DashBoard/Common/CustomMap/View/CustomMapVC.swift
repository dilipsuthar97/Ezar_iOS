//
//  CustomMapVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 1/27/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import MapKit

protocol CustomMapVCDelegate
{
    func getLocationData(_ lat: Double ,_ long :Double ,_ name:String? ,_ address : String?)
}

class CustomMapVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate , MKMapViewDelegate{
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtFieldSearch: CustomTextField!
    @IBOutlet weak var closeButtonAction: ActionButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var selectLocationBtn: ActionButton!
     @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var selectLocationLbl: UILabel!
    
    var delegate : CustomMapVCDelegate!
    var autocompleteController = GMSAutocompleteViewController()
    //s
    var placesClient : GMSPlacesClient?
    
    let locationManager = CLLocationManager()
    let locationViewModel : SearchLocationModel = SearchLocationModel()
    var latitude   : Double = 0.0
    var longitude  : Double = 0.0
    var locations = [Locations]()
    let regionRadius: CLLocationDistance = 1000
    var token = 0
    var locationName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNearByPlacesAPI()
        showCurrentLocation()
        self.txtFieldSearch.placeholder = TITLE.customer_search_location.localized
        // For use in foreground
        selectLocationLbl.text = TITLE.customer_select_this_location.localized
            
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        //        if let coor = map.userLocation.location?.coordinate{
        //            map.setCenter(coor, animated: true)
        //        }
        
        reloadTable()
        
        closeButtonAction.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
        }
        //        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //        self.map.setRegion(region, animated: true)
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = map.centerCoordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        self.map.addAnnotation(annotation)
        
        self.selectLocationBtn.touchUp = { button in
            self.delegate.getLocationData(self.latitude, self.longitude, self.locationName, self.locationName)
            
        }
//        if self.latitude != 0.0 && self.longitude != 0.0{
//            let lat = String(self.latitude)
//            let long = String(self.longitude)
//            locationViewModel.getAddressForLatLng(latitude: lat, longitude: long)
//        }
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showCurrentLocation()
    }
    
    func showCurrentLocation(){
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        location.fetchCityAndCountry { city, country, locality, pinCode, error  in
            guard let city = city, let country = country,let locality = locality,let pinCode = pinCode, error == nil else { return }
            print( city + ", " + locality + ", " + country)
            self.locationName = String(format: "%@ %@ %@ %@", city , locality ,country ,pinCode)
        
            if !self.locationName.isEmpty{
                self.currentLocationLabel.text =  self.locationName
            }else{
                self.currentLocationLabel.text =  ""
            }
        
//        if !self.locationViewModel.currentAddress.isEmpty{
//            self.currentLocationLabel.text = self.locationViewModel.currentAddress
//        }else{
//             self.currentLocationLabel.text = ""
        }
    }
    func fetchNearByPlacesAPI() {
        
        // self.locations.removeAll()
        locationViewModel.fetchNearByPlaces(self.latitude, long: self.longitude) { (locations) in
            self.locations = locations
            
            DispatchQueue.main.async {
                if locations.count > 0{
                    self.tblView.removeFootView()
                }
                self.tblView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //self.latitude = locValue.latitude
        //self.longitude = locValue.longitude
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        //        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //        self.map.setRegion(region, animated: true)
        //
        //        let annotation = MKPointAnnotation()
        //        annotation.coordinate = locValue
        //        annotation.title = ""
        //        annotation.subtitle = TITLE.customer_current_location.localized
        //        map.addAnnotation(annotation)
        
        // self.fetchNearByPlacesAPI()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = map.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Remove all annotations
        self.map.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        self.map.addAnnotation(annotation)
        self.latitude = annotation.coordinate.latitude
        self.longitude = annotation.coordinate.longitude
        print("Region Changed \(self.latitude)   \(self.longitude)")
        
        self.fetchNearByPlacesAPI()
        self.showCurrentLocation()
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            let droppedAt = view.annotation?.coordinate
            print(droppedAt.debugDescription)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.selectionStyle = .none
        
        if locations.count > 0{
            if locations.count >= indexPath.row{
                let locationsData = locations[indexPath.row]
                cell.textLabel?.text = locationsData.name
                cell.textLabel?.numberOfLines = 0
                if let desc = locationsData.vicinity{
                    cell.detailTextLabel?.text = desc
                    cell.detailTextLabel?.numberOfLines = 0
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let locationsData = locations[indexPath.row]
        let latitude =  locationsData.latitude
        let longitude = locationsData.longitude
        let address = locationsData.name
        let formattedAddress = locationsData.vicinity
        
        delegate.getLocationData(latitude, longitude, address, formattedAddress)
        
    }
    
    //MARK:-PlacesInAuToComplete
    func getPlacesInAuToComplete(){
        autocompleteController.delegate = self
        autocompleteController.accessibilityLanguage =  LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar"
        present(autocompleteController, animated: true, completion: nil)
    }
}

//MARK:-GMSAutocompleteViewControllerDelegate
extension CustomMapVC : GMSAutocompleteViewControllerDelegate{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate.getLocationData(place.coordinate.latitude, place.coordinate.longitude, place.name, place.formattedAddress)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK:- Textfield delegate
extension CustomMapVC : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        getPlacesInAuToComplete()
        
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //
    //        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
    //        NSObject.cancelPreviousPerformRequests(withTarget: self)
    //
    //        if text == "" {
    //            self.perform(#selector(self.searchLocation(searchText:)), with: text, afterDelay: 0)
    //
    //        } else {
    //            fetchNearByPlacesAPI()
    //            self.removeData()
    //
    //        }
    //
    //        return true
    //    }
    
    //    @objc func searchLocation(searchText : String) {
    
    //        self.locationViewModel.searchPlaces(searchText, lat: "", long: "") { (locations) in
    //            self.locations.removeAll()
    //            self.locations = locations
    //            self.reloadTable()
    //        }
    //        self.dismiss(animated: true, completion: nil)
    //        getPlacesInAuToComplete()
    //    }
    
    func removeData() {
        self.locations.removeAll()
        self.reloadTable()
        self.tblView.emptyBgViewLatest(top: TITLE.customer_search.localized, bottom: TITLE.customer_search_text.localized,height:(APP_DELEGATE.window?.frame.size.height)! - 250)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            if let text = self.txtFieldSearch.text {
                if text.count > 2 {
                    if self.locations.count < 1 {
                        self.tblView.emptyBgViewLatest(top: "", bottom: TITLE.customer_noData_available.localized,height:(APP_DELEGATE.window?.frame.size.height)! - 250)
                    }
                } else {
                    if self.locations.count < 1 {
                        self.tblView.emptyBgViewLatest(top: TITLE.customer_search.localized, bottom: TITLE.customer_search_text.localized,height:(APP_DELEGATE.window?.frame.size.height)! - 250)
                        // INotifications.show(message:TITLE.customer_search_text.localized)
                    }
                }
            }
            
            UIView.transition(with: self.tblView, duration: 0.5, options: .transitionCrossDissolve,
                              animations: {
                                self.tblView.reloadData()
            })
        }
    }
}




