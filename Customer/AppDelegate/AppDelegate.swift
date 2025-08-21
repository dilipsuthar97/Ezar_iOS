//
//  AppDelegate.swift
//  Customer
//
//  Created by Arvind Vlk on 12/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker
import FBSDKLoginKit
import GoogleSignIn
import CoreLocation
import UserNotifications
import Alamofire
import FirebaseCore
import FirebaseMessaging
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let locationMgr = CLLocationManager()
    let tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        EzarApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "all")

        // firebase Deeplink set url scheme
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = deepLinkURLScheme

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Firebase push notificaiton
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        Messaging.messaging().delegate = self
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
        
        if let options = launchOptions,
           let remoteNotif = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            handlePushNotification(userInfo: remoteNotif)
        }
        
        EzarApp.setRootViewController(type: LandingViewController.self)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) {
        EzarApp.isConnectedToInternet()
    }

    func applicationWillTerminate(_ application: UIApplication) { }

    // get unique token from APNs
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    ////
    // FCMToken ReceiveRegistrationToken
    func messaging(_: Messaging,
                   didReceiveRegistrationToken fcmToken: String?) {
        print("TOKEN>>>> \(fcmToken ?? "")")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        if let token = fcmToken {
            LocalDataManager.setDeviceToken(token)
        }
    }

    // Receive displayed notifications for iOS 10 devices.
    internal func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler([[.list, .sound, .badge]])
    }

    // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        handlePushNotification(userInfo: userInfo)
        completionHandler()
    }
            
    // URI scheme links handler
    // ...
    // ...
    // ...
    //
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let params = NSMutableDictionary()
        let urlString = url.absoluteString
        let kvPairs : [String] = urlString.components(separatedBy: "&")
        for param in  kvPairs {
            let keyValuePair : Array = param.components(separatedBy: "=")
            if keyValuePair.count == 2 {
                params.setObject(keyValuePair.last!, forKey: keyValuePair.first! as NSCopying)
            }
        }
        
        _ = params["ezarapp://page"] ?? ""
        let order_id = params["order_id"] ?? ""
        let measurement_id = params["measurement_id"] ?? ""
        
        let vc = OrderTrackingVC.loadFromNib()
        vc.deepLinkorderId = order_id as! String
        vc.measurement_id = measurement_id as! String

        let controller = getTheHomeViewControllerFromBase()
        controller.navigationController?.pushViewController(vc, animated: true)
        
        return FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                     open: url,
                                                                     options: options) ||
        GIDSignIn.sharedInstance().handle(url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    // Handle the deep link. For example, show the deep-linked content or
    // apply a promotional offer to the user's account.
    // ...
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleDynamicLink(dynamicLink: dynamicLink)
            return true
        }
        return false
    }
    
    
    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let incomingURL = userActivity.webpageURL else {
            return false
        }
        
        print("incomingURL: \(incomingURL)")
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            if let dynamicLink = dynamicLink {
                self.handleDynamicLink(dynamicLink: dynamicLink)
            }
        }
                
        if handled {
            return true
        }
        else {
            return handleUniversalLink(incomingURL: incomingURL)
        }
    }
}

// MARK: - handle links received as Universal Links when the app is already installed

extension AppDelegate {
    func handleDynamicLink(dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            return
        }
        print("Your incoming link params : \(url.absoluteString)")
        guard let uRLs = URL(string: url.absoluteString) else { return }
        if let invite_code = uRLs.value(for: "invite_code") {
            LocalDataManager.saveInviteCode(invite_code)
        }
    }
    
    func handleUniversalLink(incomingURL: URL) -> Bool {
        guard let components = URLComponents(url: incomingURL,
                                             resolvingAgainstBaseURL: true) else {
            return false
        }
        var type = ""
        var id = ""
        var app_mode = ""
        var category_id = ""

        if components.queryItems?.count ?? 0 > 0 {
            for queryItem in components.queryItems ?? [] {
                switch queryItem.name.uppercased() {
                case UniversalLinkVariable.NAME.rawValue.uppercased():
                    type = queryItem.value ?? ""
                    break
                case UniversalLinkVariable.ID.rawValue.uppercased():
                    id = queryItem.value ?? ""
                    break
                case UniversalLinkVariable.APP_MODE.rawValue.uppercased():
                    app_mode = queryItem.value ?? ""
                    break
                case UniversalLinkVariable.CATEGORY_ID.rawValue.uppercased():
                    category_id = queryItem.value ?? ""
                    break
                default:
                    break
                }
            }
        }
        
        if !(app_mode.isEmpty) {
            LocalDataManager.setUserSelection(app_mode)
        }
        
        let controller = getTheHomeViewControllerFromBase()
        var isAllow : Bool = false
        
        let vc = SellerDetailVC.loadFromNib()
        if type.uppercased() == "MANUFACTURE" {
            isAllow = true
            vc.classType = .HOMEREQUESTSVC
            vc.isRatingAvail = false
            vc.detailClassType = .CHOOSESTYLE
            vc.viewModel.vendor_id = Int(id) ?? 0
            vc.viewModel.category_id = Int(category_id) ?? 0
            vc.viewModel.is_promotion = 1
            COMMON_SETTING.max_capacity = 15
            COMMON_SETTING.quantity = 1
            COMMON_SETTING.deliveryDate = "\(Date().third_DayFormToday)"
        }
        else if type.uppercased() == "PRODUCT", app_mode.uppercased() == "T" {
            isAllow = true
            vc.classType = .HOMEREQUESTSVC
            vc.bottomBtnTitle = TITLE.chooseStyles.localized
            vc.isRatingAvail = true
            vc.viewModel.product_id = Int(id) ?? 0
            vc.detailClassType = .CHOOSESTYLE
            vc.viewModel.is_promotion = 1
            COMMON_SETTING.max_capacity = 15
        }
        else if type.uppercased() == "PRODUCT" {
            isAllow = true
            vc.bottomBtnTitle = TITLE.choose.localized
            vc.isRatingAvail = false
            vc.detailClassType = .READYMADE
            vc.viewModel.product_id = Int(id) ?? 0
            vc.classType = .PRODUCTSVC
            COMMON_SETTING.max_capacity = 15
        }
        
        if controller is HomeRequestsVC, isAllow {
            controller.navigationController?.pushViewController(vc, animated: true)
        }
        return true
    }
}


// MARK: - Handle PushNotification
extension AppDelegate {
        
    func handlePushNotification(userInfo: [AnyHashable:Any]) {
        let deepLink = userInfo["deeplink"] as? String ?? ""
        let params = NSMutableDictionary()
        let kvPairs = deepLink.components(separatedBy: "&")
        for param in  kvPairs {
            let keyValuePair = param.components(separatedBy: "=")
            if keyValuePair.count == 2 {
                params.setObject(keyValuePair.last!, forKey: keyValuePair.first! as NSCopying)
            }
        }
        
        let page = params["ezarapp://page"] as? String ?? ""
        if page == "order" {
            let order_id = params["order_id"] ?? ""
            let measurement_id = params["measurement_id"] ?? ""
            let vc = OrderTrackingVC.loadFromNib()
            vc.deepLinkorderId = order_id as! String
            vc.measurement_id = measurement_id as! String
            
            let controller = getTheHomeViewControllerFromBase()
            controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getTheHomeViewControllerFromBase() -> UIViewController {
        var controller : BaseViewController = BaseViewController()
        if self.window?.rootViewController is AVNavigationController {
            for ctler in self.window?.rootViewController?.children ?? [] {
                if ctler is HomeRequestsVC {
                    controller = ctler as! BaseViewController
                    break
                }
            }
        }
        return controller
    }
}

