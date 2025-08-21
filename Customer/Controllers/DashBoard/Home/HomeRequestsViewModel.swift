//
//  LoginViewModel.swift
//  Thoab
//
//  Created by webwerks on 09/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import Foundation
import Alamofire

//setup UserViewModel that inherites from NSObject

class HomeRequestsViewModel: NSObject {
    
    let APIClient : HomeRequestsAPIClient
    var root_Category           : Int = 0
    var productType             : String = ""
    var homeCategoryList        : HomeCategory?
    var exploreProductList      : HomeCategory?
    var homePromotions          : [HomePromotion] = [HomePromotion]()
    var bottomPromotionsList    : [HomePromotion] = [HomePromotion]()
    var responseMessage         : String = ""
    var responseMSG             : String = ""
    var statusCode         : Int = 0

    init(apiClient: HomeRequestsAPIClient = HomeRequestsAPIClient()) {
        self.APIClient = apiClient
    }
    
    //Home Category
    func getHomeCategory(complete: @escaping isCompleted) {
        let params : NSMutableDictionary = [API_KEYS.root_category : self.root_Category,
                                            API_KEYS.lang : COMMON_SETTING.lang,
                                            API_KEYS.product_type : self.productType,
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.homeCategory(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data {
                    self.homeCategoryList = data
                }
                self.responseMessage = response.message ?? ""
                complete()
            }, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    //Explore More Product
    func exploreMoreProduct(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.root_category : self.root_Category,
                                            API_KEYS.product_type : self.productType]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.homeExploreMoreProduct(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data
                {
                    self.exploreProductList = data
                    complete()
                }
            }, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    //MARK:-  Home promotions
    
    func getHomePromotions(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.root_category : self.root_Category,
                                            API_KEYS.product_type : self.productType]
        
        if COMMON_SETTING.isConnectedToInternet() {
            
            IProgessHUD.show()
            
            APIClient.homePromotions(for: params, completionHandler: { (response) in
                self.statusCode = response.code ?? 0
                self.responseMSG = response.message ?? ""
                IProgessHUD.dismiss()
                
                if let data = response.data, data.count > 0
                {
                    self.homePromotions = data
                    if let bottomList = response.bottomData,bottomList.count > 0 {
                        self.bottomPromotionsList = bottomList
                    }
                    complete()
                }
            }, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    //MARK:-  Offer Home promotions    
    func getHomePromotionsOffer(complete: @escaping isCompleted) {
        let params : NSMutableDictionary = [API_KEYS.root_category : self.root_Category,
                                            API_KEYS.product_type : self.productType]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.homePromotionsOffer(for: params, completionHandler: { (response) in
                self.statusCode = response.code ?? 0
                self.responseMSG = response.message ?? ""
                IProgessHUD.dismiss()
                
                if let data = response.data, data.count > 0 {
                    self.homePromotions = data
                    if let bottomList = response.bottomData,bottomList.count > 0{
                        self.bottomPromotionsList = bottomList
                    }
                    complete()
                }
            }, complete: {
                IProgessHUD.dismiss()
                complete()
            })
        }
    }
    
    func getRegisterDeviceToken(_ complete: @escaping isCompleted) {
        guard let customerId = Profile.loadProfile()?.id else {
            return
        }
        
        let deviceToken = LocalDataManager.getDeviceToken()
        let deviceTokenType = "ios"
        let params : NSMutableDictionary = [API_KEYS.customer_id : customerId,
                                            API_KEYS.device_token : deviceToken,
                                            API_KEYS.device_token_type : deviceTokenType]
                
        if COMMON_SETTING.isConnectedToInternet() {
            APIClient.RegisterDeviceToken(for: params) { (response) in
                if let status = response.code, status == 200{
                    LocalDataManager.setDeviceTokenRegister(true)
                }
                complete()
            }
        }
    }
}
