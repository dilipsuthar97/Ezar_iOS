//
//  NearestDelegateViewModel.swift
//  Customer
//
//  Created by webwerks on 7/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

//class MyRequestDetailViewModel : NSObject
//{
//    var latitude : String = ""
//    var longitude : String = ""
//    var delegate_id : Int = 0
//    var customer_id : Int = Profile.loadProfile()?.id ?? 0
//    var product_type : String = LocalDataManager.getUserSelection()
//    var mobile_number : String = ""
//    var customerAddress : String = ""
//    var quote_id : String = ""
//    var request_for : String = ""
//    var request_information : String = ""
//    var request_id : Int = 0
//    var delegate_status : String = ""
//    
//    func setRequestFor(item_quote_id : String, type : String)
//    {
//        let request_for : [String : String] = ["item_quote_id": item_quote_id,  "type": type]
//        self.request_for = COMMON_SETTING.json(from: request_for) ?? ""
//    }
//    
//    func setRequestInformation(location_name : String, location_type : String, instructions: String)
//    {
//        let request_information : [String : String] = ["location_name":location_name,
//                                                       "location_type":location_type,
//                                                       "instructions":instructions]
//        self.request_information = COMMON_SETTING.json(from: request_information) ?? ""
//    }
//}

class MyRequestDetailViewModel: NSObject {

    let APIClient : MyRequestDetailAPIClient!
    var delegateDetail : DelegateDetail? = nil
    var latitude : String = ""
    var longitude : String = ""
    var delegate_id : Int = 0
    var request_id : Int = 0
    var origin_lat : Double = 0.0
    var origin_lon : Double = 0.0
   var delegate_status : String = ""

    init(apiClient: MyRequestDetailAPIClient = MyRequestDetailAPIClient()) {
        self.APIClient = apiClient
    }
    
    //NearestDelegateList Options
    func getRequestDetail(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.request_id : request_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.myRequestDetail(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data
                {
                    self?.delegateDetail = data
                    complete()
                }
            })
        }
    }
}






