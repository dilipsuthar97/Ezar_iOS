//
//  FacebookHelper.swift
//  Customer
//
//  Created by webwerks on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookHelper: NSObject {

    static let fbHelper = FacebookHelper()
    var isLoggedIn = false
    var userDetails = anyDict()
    var fbID : String = ""
    var fbUserName : String = ""
    
    func fetchFbUserDetails(viewController : UIViewController , completionHandler:@escaping (Bool, anyDict)-> Void ){
        
        
        let fbloginManger: FBSDKLoginManager = FBSDKLoginManager()
        
        fbloginManger.logOut()
        
        fbloginManger.logIn(withReadPermissions: ["email"], from:viewController) {(result, error) -> Void in
            
            if(error == nil){
                
                let fbLoginResult: FBSDKLoginManagerLoginResult  = result!
                
                if( result?.isCancelled)!{
                    completionHandler(self.isLoggedIn, self.userDetails)
                    return
                }
                if(fbLoginResult .grantedPermissions.contains("email")){

                    self.getFbId(completionHandler: { (isSuccess, details) in
                        completionHandler(isSuccess, details)
                    })
                }
            }
            else{
                completionHandler(self.isLoggedIn, self.userDetails)
            }
        }
    }
 
    func getFbId(completionHandler:@escaping (Bool, anyDict)-> Void ){
        
        if(FBSDKAccessToken.current() != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,email"]).start(completionHandler: { (connection, result, error) in
                
                if let  Info = result as? [String: Any] {
                    
                    if error == nil {
                        let dict = ["email":Info["email"] ?? "", "id" : Info["id"] ?? "", "name" : Info["name"] ?? ""]
                        completionHandler(true, dict)
                    }
                    else{
                        completionHandler(self.isLoggedIn, self.userDetails)
                    }
                }
                else{
                    completionHandler(self.isLoggedIn, self.userDetails)
                }
            })
        }
    }
}
