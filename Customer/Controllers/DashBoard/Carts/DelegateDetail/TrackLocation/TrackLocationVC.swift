//
//  TrackLocationVC.swift
//  Customer
//
//  Created by webwerks on 27/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import STPopup
import SafariServices

class TrackLocationVC: BaseViewController, GMSMapViewDelegate {

    //MARK:- Variable declaration
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var callBtn: ActionButton!
    @IBOutlet weak var msgBtn: ActionButton!
    @IBOutlet weak var directionsBtn: ActionButton!
    @IBOutlet weak var whiteBackgroundView: UIView!
    var originlat : Double = 0.0
    var originlong : Double = 0.0
    var destinationlat : Double = 0.0
    var destinationlong : Double = 0.0
    var mobileNumber : String?
    var delegateId  :Int = 0

    var locations = [anyDict]()
    
    //MARK:- View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showDirection()
        setUpNavigationBarUI()
        callBtn.setTitle(TITLE.call.localized, for: .normal)
        directionsBtn.setTitle(TITLE.customer_get_directions.localized, for: .normal)
        msgBtn.setTitle(TITLE.customer_message.localized, for: .normal)

        callBtn.touchUp = { button in
            if let mobNumber = self.mobileNumber, mobNumber != ""{
            if let url = URL(string: "tel://\(mobNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            }else{
       COMMON_SETTING.showAlertMessage(
        "", message: TITLE.customer_error_empty_mobile.localized, currentVC: self)
            }
        }
        
        msgBtn.touchUp = { button in
            let vc = MessagePopUpVC.loadFromNib()
            vc.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 380)
            let profile  = Profile.loadProfile()
            vc.viewModel.customer_id = profile?.id ?? 0
            vc.viewModel.delegate_id = self.delegateId
            vc.viewModel.isCustomer = 1
            let popupController = STPopupController.init(rootViewController: vc)
            popupController.transitionStyle = .fade
            popupController.containerView.backgroundColor = UIColor.clear
            popupController.backgroundView?.backgroundColor = UIColor.black
            popupController.backgroundView?.alpha = 0.7
            popupController.hidesCloseButton = true
            popupController.navigationBarHidden = true
            popupController.present(in: self)
        }
        
        directionsBtn.touchUp = { button in
            let destination = "\(self.originlat),\(self.originlong)"
            let origin = "\(self.destinationlat),\(self.destinationlong)"
            let url = "http://maps.google.com/maps?saddr=\(origin)&daddr=\(destination)"
            if let Url = URL(string: url) {
                let vc = SFSafariViewController(url: Url, entersReaderIfAvailable: true)
                self.present(vc, animated: true)
            }
        }
    }
    
    func setUpNavigationBarUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.TrackLocation.localized
    }
    
    
    func showDirection()
    {
        let camera = GMSCameraPosition.camera(withLatitude: originlat,
                                              longitude: originlong,
                                              zoom: 10.0,
                                              bearing: 30,
                                              viewingAngle: 40)
        //Setting the mapView
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView?.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.animate(to: camera)
        //self.view.addSubview(self.mapView)
        let origin = "\(originlat),\(originlong)"
        let destination = "\(destinationlat),\(destinationlong)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        //Rrequesting Alamofire and SwiftyJSON
        Alamofire.request(url).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = UIColor.blue
                    polyline.strokeWidth = 2
                    polyline.map = self.mapView
                }
            }catch{
                
            }
        }
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: originlat, longitude: originlong)
        marker.map = mapView
        marker.icon = UIImage.init(named: "pin_blue")
        marker.title = TITLE.customer.localized

        //28.643091, 77.218280
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: destinationlat, longitude: destinationlong)
        marker1.map = mapView
        marker1.icon = UIImage.init(named: "pin_red")
        marker1.title = TITLE.customer_delegate.localized

    }
}
