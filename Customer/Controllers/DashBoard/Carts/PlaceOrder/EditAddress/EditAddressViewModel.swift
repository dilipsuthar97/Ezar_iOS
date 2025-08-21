//
//  EditAddressViewModel.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class EditAddressViewModel: NSObject
{
    var editAddressFieldList =  [TITLE.Name.localized,
                                 TITLE.ContactNumber.localized,
                                 TITLE.DeliveryInstructions.localized,
                                 TITLE.ChooseYourLocation.localized]
    
    
    let APIClient : EditAddressAPIClient
    var shippingMethodList : [ShippingMethods] = [ShippingMethods]()
    
    var customer_id : Int = 0
    var cart_item_collection : [Any] = []
    var shoppingBagItems : ShoppingBagItem? 
    
    var name : String = ""
    var address : String = ""
    var street : String = ""
    var postCode : String = ""
    var city : String = ""
    var state : String = ""
    var country : String = "" //country Name Initials
    var countryCode : String = ""
    var contactNumber : String = ""
    var addressType : String = ""
    var instruction : String = ""
    var longitude   : String = "" //Double = 0.00
    var latitude    : String = ""//Double = 0.00
    var countryName: String = ""
    var isDefaultAddress : Int = 0
    var isNewAddress : Int = 1
    var addressId : Int = 0
    var countryInitial : String = ""
    var giftWrap : Int = 0

    
    var requestDelegateModel : RequestDelegateModel = RequestDelegateModel()
    
    
    init(apiClient: EditAddressAPIClient = EditAddressAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Product Options
    func getShippingMethods(complete: @escaping isCompleted) {
        
        if isNewAddress == 1{
            var isoCountryInfo = IsoCountryCodes.searchByName(calling: countryCode)
            if (isoCountryInfo.alpha2.isEmpty)
            {
                isoCountryInfo = IsoCountryCodes.searchByCountryCode(countryCode: country)
            }
            countryInitial = isoCountryInfo.alpha2
        }else{
            countryInitial = self.country
        }
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.state : state,
                                            API_KEYS.country : countryInitial]
        
        if LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue
        {
            params.removeAllObjects()
            params.addEntries(from: [API_KEYS.customer_id : customer_id,
                                     API_KEYS.state : state,
                                     API_KEYS.country : countryInitial,
                                     API_KEYS.quote_id : self.shoppingBagItems?.quote_id ?? "",
                                     API_KEYS.product_type : LocalDataManager.getUserSelection()])
        }
        
    
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ShippingMethods(for: params, completionHandler: { [weak self] (response) in
                IProgessHUD.dismiss()
                if let data = response.data, data.count > 0
                {
                    self?.shippingMethodList = data
                    complete()
                }else{
                    INotifications.show(message: response.message ?? "")
                }
            })
        }
    }
    
    
}
