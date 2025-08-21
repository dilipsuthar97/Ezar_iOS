//
// EditProfileViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 18/05/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject
class EditProfileViewModel: NSObject {
    
    let APIClient : EditProfileAPIClient
    var name : String = ""
    var customerId : Int = 0
    var email : String = ""
    var mobileNumber :String = ""
    var dateOfBirth : String = ""
    var city : String = ""
    var countryCode : String = ""
    var country : String = ""
    
    var profileImage : [MultipartFile]? = nil
        
    init(apiClient: EditProfileAPIClient = EditProfileAPIClient()) {
        self.APIClient = apiClient
    }
    
    func editProfileWS(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.name: name,
                                            API_KEYS.customer_id: Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.email: email,
                                            API_KEYS.mobile_number: mobileNumber,
                                            API_KEYS.dob: dateOfBirth,
                                            API_KEYS.city: city,
                                            API_KEYS.country_code: countryCode,
                                            API_KEYS.country: country]
        
        APIClient.editProfile(for: params,
                              images: profileImage,
                              completionHandler: { (response) in
            IProgessHUD.dismiss()
            if let data = response.data {
                let profile = Profile.loadProfile()
                profile?.name = data.name
                profile?.email = data.email!
                profile?.profileImg = data.profileImage
                profile?.mobileNo = data.mobile_number
                profile?.dob = data.dob
                profile?.city = data.city
                profile?.country = data.country
                profile?.country_code = data.country_code
                Profile.save(profile!)
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        })
    }
}
