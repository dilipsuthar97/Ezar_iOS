//
//  AppDelegate+Config.swift
//  Homekooc
//
//  Created by Volkoff on 08/08/19.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation
import GoogleMaps
import GooglePlacePicker
import FBSDKLoginKit
import GoogleSignIn
import FirebaseCore
import FirebaseMessaging

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

class EzarApp: NSObject {
    static func configure() {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first
        print(documentsUrl ?? "")
        
        Localizer.DoTheExchange()
        Localizator.sharedInstance.changeTheValueOflocalizableDictionary()
        DropDown.startListeningToKeyboard()

        APP_DELEGATE.setUpLocation()
        IProgessHUD.configure()
        
        GMSPlacesClient.provideAPIKey(GoogleKeys.placesKey)
        GMSServices.provideAPIKey(GoogleKeys.placesKey)
        GIDSignIn.sharedInstance().clientID = GoogleKeys.customerSignInKey
        UIApplication.shared.isIdleTimerDisabled = true
        UIView.appearance().semanticContentAttribute = COMMON_SETTING.getRTLOrLTRAligment()
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
    }

    static func setRootViewController<T: UIViewController>(type _: T.Type) {
        let vc = T.loadFromNib()
        let navC = AVNavigationController(rootViewController: vc)
        navC.navigationBar.transparentNavigationBar()
        navC.addShadowView()
        APP_DELEGATE.window?.rootViewController = navC
        APP_DELEGATE.window?.backgroundColor = UIColor.black
        APP_DELEGATE.window?.makeKeyAndVisible()
    }
    
    static func setLanguageRootViewController(isArabic: Bool) {
        Language.setAppleLanguage(isArabic ? "ar" : "en")
        Localizer.DoTheExchange()
        UIView.appearance().semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
        Localizator.sharedInstance.changeTheValueOflocalizableDictionary()
        APP_DELEGATE.setHomeView()
    }
    
    static func isConnectedToInternet() {
        if NetworkReachabilityManager()!.isReachable == false {
            INotifications.show(message: MESSAGE.noInternet.localized, type: .error)
        }
    }
}

extension AppDelegate: UITabBarControllerDelegate {
    
    func setHomeView() {
        
        let tabViewController1 = HomeRequestsVC.loadFromNib()
        let nav1 = AVNavigationController(rootViewController: tabViewController1)
        nav1.addShadowView()
        nav1.view.tag = 10
        
        let tabViewController2 = OfferVC.loadFromNib()
        let nav2 = AVNavigationController(rootViewController: tabViewController2)
        nav2.addShadowView()
        nav2.view.tag = 20
        
        let tabViewController3 = ShoppingBagVC.loadFromNib()
        let nav3 = AVNavigationController(rootViewController: tabViewController3)
        nav3.addShadowView()
        nav3.view.tag = 30
        
        let tabViewController4 = ProfileVC.loadFromNib()
        let nav4 = AVNavigationController(rootViewController: tabViewController4)
        nav4.addShadowView()
        nav4.view.tag = 40
        
        tabBarController.viewControllers = [nav1, nav2, nav3, nav4]
        tabBarController.delegate = self
        

        tabBarController.tabBar.items![0].title = "home".localized
        tabBarController.tabBar.items![1].title = "offers".localized
        tabBarController.tabBar.items![2].title = "carts".localized
        tabBarController.tabBar.items![3].title = "profile".localized
        
        tabBarController.tabBar.items![0].image = UIImage(named: "Tab1")
        tabBarController.tabBar.items![1].image = UIImage(named: "Tab2")
        tabBarController.tabBar.items![2].image = UIImage(named: "Tab3")
        tabBarController.tabBar.items![3].image = UIImage(named: "Tab4")
        
        tabBarController.tabBar.items![0].imageInsets = UIEdgeInsets(top: 2,
                                                                     left: 0,
                                                                     bottom: 0,
                                                                     right: 0)
        tabBarController.tabBar.items![1].imageInsets = UIEdgeInsets(top: 2,
                                                                     left: 2,
                                                                     bottom: 2,
                                                                     right: 2)
        tabBarController.tabBar.items![2].imageInsets = UIEdgeInsets(top: 2,
                                                                     left: 0,
                                                                     bottom: 0,
                                                                     right: 0)
        tabBarController.tabBar.items![3].imageInsets = UIEdgeInsets(top: 4,
                                                                     left: 0,
                                                                     bottom: 0,
                                                                     right: 0)
        
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = Theme.primaryColor
        UITabBar.appearance().backgroundColor = Theme.white
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: FontType.regular(size: 14)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBarController.tabBar.frame.width, height: 1))
        lineView.backgroundColor = Theme.bgColor
         lineView.addShadow()
        tabBarController.tabBar.insertSubview(lineView, at: 0)
        
        tabBarController.selectedIndex = 1
        tabBarController.selectedViewController = tabBarController.viewControllers![0]
        COMMON_SETTING.isRootViewController = true
        
        let VC  = SideMenuVC.loadFromNib()
        let rootController = FAPanelController()
        rootController.configs.leftPanelWidth = 300
        rootController.configs.rightPanelWidth = 300
        
        rootController.leftPanelPosition = .front
        rootController.rightPanelPosition = .front
        
        rootController.tempViewContoller = VC
        _ = rootController.center(tabBarController)
        
        let language = LocalDataManager.getSelectedLanguage()
        if language == LanguageSelection.ENGLISH.rawValue {
            _ = rootController.left(VC)
        } else {
            _ = rootController.right(VC)
        }
        
        UIView.transition(with: window!,
                          duration: 0,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: {
            self.window?.rootViewController = rootController
            self.window?.rootViewController?.view.backgroundColor = UIColor.white
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }, completion: nil)
    }
    
    func hideTabBarAnimated() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
            self.tabBarController.tabBar.frame.size.height = 0
            self.tabBarController.tabBar.isHidden = true
        })
    }
    
    func updateBadgeCount(count: Int) {
        if let tabItems = APP_DELEGATE.tabBarController.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
            if count > 0 {
                tabItem.badgeValue = "\(count)"
            }
        }
    }
    
    func setUpLocation() {
       locationMgr.delegate = self
       let status  = CLLocationManager.authorizationStatus()
       if status == .notDetermined {
           locationMgr.requestWhenInUseAuthorization()
       }
   }
}

//MARK: - CLLocationManagerDelegate
extension AppDelegate : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        // comapring Authorization Status and perfrom operation accordingly
        LocalDataManager.setUserLocation(false)
        switch status {
        case .authorizedWhenInUse:
            print("Authorized When In Use")
            LocalDataManager.setUserLocation(true)
            break
        case .authorizedAlways:
            print("Authorized Always")
            LocalDataManager.setUserLocation(true)
            break
        default:
            break
        }
    }
}

