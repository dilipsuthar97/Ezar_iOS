//
//  RequestDelegateVC.swift
//  Customer
//
//  Created by webwerks on 4/17/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import GoogleMaps

class RequestDelegateVC: BaseViewController {

    //MARK:- Required Variables
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    @IBOutlet weak var backButton: ActionButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    var locations = [anyDict]()
    var bottomView = ContainerView()
    var requestDelegateModel : RequestDelegateModel = RequestDelegateModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        self.customBottonBar()
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            print("latitude - \(coordinate.latitude) **** longatide - \(coordinate.longitude)")
            self.addressLabel.text = lines.joined(separator: "\n")
            self.requestDelegateModel.customerAddress = self.addressLabel.text ?? ""
            self.requestDelegateModel.latitude = String(describing :coordinate.latitude)  //Testing
            
            self.requestDelegateModel.longitude = String(describing :coordinate.longitude)  //Testing
            
            let labelHeight = 64
            if #available(iOS 11.0, *) {
                self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                    bottom: CGFloat(labelHeight), right: 0)
            } else {
                // Fallback on earlier versions
            }
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            places.forEach {
                let marker = PlaceMarker(place: $0)
                marker.map = self.mapView
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBarUI()
    }
    
    //MARK:- Navigation Bar UI
    func setUpNavigationBarUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.backButton.touchUp = { button in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Helpers Maps
    func showMarkersOnMap(_ locations : [anyDict])
    {
        for location in locations
        {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude:location["lat"] as! Double , longitude:location["long"] as! Double)
            marker.map = mapView
            marker.icon = UIImage(named: "location_Blue")
            let path = GMSMutablePath()
            path.add(marker.position)
            mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path), withPadding:0))
        }
    }
    
    //MARK:- Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.USETHISADDRESS.localized.uppercased(),TITLE.editAddress.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 55)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - CLLocationManagerDelegate
extension RequestDelegateVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(coordinate: location.coordinate)
    }
}

// MARK: - GMSMapViewDelegate
extension RequestDelegateVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if (gesture) {
            mapCenterPinImage.fadeIn(withDuration: 0.25)
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard marker is PlaceMarker else {
            return nil
        }
        
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(withDuration: 0.25)
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(withDuration: 0.25)
        mapView.selectedMarker = nil
        return false
    }
}

//MARK:- ContainerView (Bottom Button) Delegate Method
extension RequestDelegateVC : ButtonActionDelegate
{
    func onClickBottomButton(button: UIButton) {
        let vc = EditAddressVC.loadFromNib()
        vc.isRequestDelegate = true
        vc.viewModel.countryCode = self.requestDelegateModel.countryCode
        vc.viewModel.contactNumber = self.requestDelegateModel.mobile_number
        vc.viewModel.requestDelegateModel = self.requestDelegateModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
