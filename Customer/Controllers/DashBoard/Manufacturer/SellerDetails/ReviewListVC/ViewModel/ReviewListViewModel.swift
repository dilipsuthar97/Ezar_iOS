//
//  ReviewListViewModel.swift
//  Customer
//
//  Created by Priyanka Jagtap on 31/05/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ReviewListViewModel: NSObject {
    var id                  : Int = 0
    let APIClient           : ReviewListAPIClient
    var reviewList          = [ReviewsList]()
    var reivewType          : String = ""
    var review_id           : Any?
    var upVote              : Int?
    var pageCount           : Int = 0
    var current_page         : Int = 1
    var total_reviews       : Int = 0

    
    init(apiClient: ReviewListAPIClient = ReviewListAPIClient()) {
        self.APIClient = apiClient
    }
    
    
    
    //All Reviews
    func getAllReviews(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.id : id,
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.review_type : reivewType ?? "",
                                            API_KEYS.current_page : current_page,
                                            API_KEYS.total_reviews : total_reviews]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.SellerAllReviews(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data,data.list.count > 0
                {
                    self.reviewList = data.list
                    
                    self.pageCount = data.page_count
                    self.current_page = data.current_page
                    complete()
                }else{
                    INotifications.show(message: response.message ?? "")
                }
            })
        }
    }
    
    
    func getAllReviewsNext(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.id : id,
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.review_type : reivewType ?? "",
                                            API_KEYS.current_page : current_page,
                                            API_KEYS.total_reviews : total_reviews]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.SellerAllReviews(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data,data.list.count > 0
                {
                    self.reviewList = self.reviewList + data.list
                    self.pageCount = data.page_count
                    self.current_page = data.current_page
                    complete()
                }else{
                    INotifications.show(message: response.message ?? "")
                }
            })
        }
    }
    
    func setReviewLikeDislike(complete: @escaping isCompleted)
    {
        let params : NSMutableDictionary = [API_KEYS.review_id : self.review_id ?? "",
                                            API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.review_type : self.reivewType ?? "",
                                            API_KEYS.up_vote : self.upVote ?? -1]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.ReviewLikeDislike(for: params) { (response) in
                IProgessHUD.dismiss()
                if let message = response.message
                {
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
}
