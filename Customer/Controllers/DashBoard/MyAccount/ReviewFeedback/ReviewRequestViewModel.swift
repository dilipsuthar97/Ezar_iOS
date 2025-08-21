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

class ReviewRequestViewModel: NSObject
{
    let APIClient           : ReviewRequestAPIClient
    var reviewFeedbacks     : AllReviewFeedback?
    var reviewFeedbacksPagination     : AllReviewFeedback?
    var reviewType = ""
    var current_page = 1
    
    
    init(apiClient: ReviewRequestAPIClient = ReviewRequestAPIClient()) {
        self.APIClient = apiClient
    }
    
    func getReviewFeedback(complete: @escaping isCompleted)
    {
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
        
            APIClient.ReviewAndFeedback(for: params) { [weak self] (response) in
                IProgessHUD.dismiss()
               
                if response.code == 200, let response = response.data
                {
                    self?.reviewFeedbacks = response
                }
                else
                {
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
                complete()
            }
        }
    }
    
    func getReviewFeedbackPagination(complete: @escaping isCompleted)
    {
        let customer_id = Profile.loadProfile()?.id ?? 0
        let params : NSMutableDictionary = [API_KEYS.customer_id : customer_id,
                                            API_KEYS.current_page : current_page,
                                            API_KEYS.review_type : reviewType]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.ReviewAndFeedbackPagination(for: params) { [weak self] (response) in
                IProgessHUD.dismiss()
                if response.code == 200, let response = response.data
                {
                    self?.reviewFeedbacksPagination = response
                }
                else
                {
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
                complete()
            }
        }
    }
}
