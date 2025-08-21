


//
//  ProfileViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 21/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewModel: NSObject {
    
    let APIClient           : ProfileAPIClient
    var customer_id         : Int = 0
    
    var myAccountDetail  : MyAccountDetails?
    
    var requestList =  [
        ["name": TITLE.Notifications, "image": "Notifications"],
        ["name": TITLE.requests, "image": "Request"],
        ["name": TITLE.Orders, "image": "Orders"],
        ["name": TITLE.MyReturns, "image": "return"],
        ["name": TITLE.Measurements, "image": "sidemeasurement"],
        ["name": TITLE.ScanIntro, "image": "faqs"],
        ["name": TITLE.Favorite, "image": "Heart"],
        ["name": TITLE.customer_rewardsHistory, "image": "Rewards"]]
    
    var settingList = [
        ["name": TITLE.Settings, "image": "sidesettings"],
        ["name": TITLE.feedbackAndReview,"image": "Feedback_Review"],
        ["name": TITLE.FAQs,"image": "faqs"],
        ["name": TITLE.Logout,"image": "Logout"]
    ]
    
    var responseCode = 0
    
    init(apiClient: ProfileAPIClient = ProfileAPIClient()) {
        self.APIClient = apiClient
    }
    
    //SubCategories
    func getMyAccountDetails(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.MyAccountDetails(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                self.responseCode = response.code ?? 0
                if let data = response.data
                {
                    self.myAccountDetail = data
                    let profile = Profile.loadProfile()
                    profile?.name = data.name
                    profile?.email = data.email
                    profile?.profileImg = data.profile_image
                    profile?.mobileNo = data.mobile_number
                    profile?.address = data.address
                    profile?.dob    = data.dob
                    profile?.city = data.city
                    profile?.country = data.country
                    profile?.country_code = data.country_code
                    profile?.notification_count = data.notification_count
                    profile?.whatsapp_us = data.whatsapp_us
                    if let profile = profile{
                      Profile.save(profile)
                    }
                    complete()
                }
            })
        }
    }
}
