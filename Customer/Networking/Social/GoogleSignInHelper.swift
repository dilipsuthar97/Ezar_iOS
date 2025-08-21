//
//  GoogleSignInHelper.swift
//  Customer
//
//  Created by webwerks on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol GoogleSignInHelperDelegate
{
    func googleSignInDetails(_ notification: [AnyHashable : Any]?)
}

class GoogleSignInHelper: NSObject, GIDSignInUIDelegate, GIDSignInDelegate {

    static let googleHelper = GoogleSignInHelper()
    var delegate : GoogleSignInHelperDelegate!
    var userDetails : anyDict = ["isLoggedin":false,"userDetails":anyDict()]
    var viewController : UIViewController?
    
    func fetchGoogleUserDetails(viewController : UIViewController){
        
        self.delegate = viewController as! GoogleSignInHelperDelegate
        GIDSignIn.sharedInstance().signOut()
        self.viewController = viewController
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()

    }
    
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        viewController!.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        viewController!.dismiss(animated: true, completion: nil)
        self.delegate.googleSignInDetails(userDetails)

    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let googleDetails = ["email":user.profile.email, "name":user.profile.name, "id" : user.userID]
            var details = userDetails
            details["isLoggedin"] = true
            details["userDetails"] = googleDetails
            
            self.delegate.googleSignInDetails(details)

            
        } else {
            print("Error occured while log in")
            self.delegate.googleSignInDetails(userDetails)
        }
    }
}
