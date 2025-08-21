//
//  ReviewFeedbackViewModel.swift
//  Customer
//
//  Created by webwerks on 9/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Alamofire

class ReviewFeedbackViewModel: NSObject
{
    let APIClient : ReviewFeedbackAPIClient
    var review_type = "" //(p for product, s for seller and d for delegate review)
    var customer_id = 0
    var star_rating = 0
    var title = ""
    var titleText = ""
    var detailDescription = ""
    var detailDescriptionText = ""
    var key_id = ""
    var value_id = 0
    var review_id = 0
    var reviewRating : String = ""
    var anyObject : AnyObject?
    var reviewQuestions : [AnyObject] = []
    var question_answers : [NSMutableDictionary] = []
    var order_item_id : Int = -1
    var message : String = ""
    var errorCode : Int?
    var selectedValue = ""
    var productId = 0
    var orderDetail : orderDetails?
    var questionAnswer :[ReviewQuestions] = []

    init(apiClient: ReviewFeedbackAPIClient = ReviewFeedbackAPIClient()) {
        self.APIClient = apiClient
    }
    
    func setReviewFeedback(complete: @escaping isCompleted)
    {
        customer_id = Profile.loadProfile()?.id ?? 0
        let jsonString : String = COMMON_SETTING.json(from: question_answers) ?? ""
        let params : NSMutableDictionary = [API_KEYS.review_type: review_type,
                                            API_KEYS.customer_id: customer_id,
                                            API_KEYS.rating: star_rating,
                                            API_KEYS.review_title: title,
                                            API_KEYS.review_description: detailDescription,
                                            key_id: value_id,
                                            API_KEYS.question_answers:jsonString]
        if order_item_id > 0
        {
            params.addEntries(from: [API_KEYS.order_item_id:order_item_id])
        }
        if review_id > 0
        {
            params.addEntries(from: [API_KEYS.review_id: review_id])
        }
       
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            APIClient.SubmitReview(for: params) { (response) in
                self.message = response.message ?? ""
                self.errorCode =  response.code
                IProgessHUD.dismiss()
            
                if let message = response.message{
                    INotifications.show(message: message)
                }
                complete()
            }
        }
    }
}
