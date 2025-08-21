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

class NotificationsViewModel: NSObject {
    
    var notificationList       : [NotificationDetails] = [NotificationDetails]()
    
    let APIClient             : NotificationsRequestsAPIClient
    var customerId            : Int = Profile.loadProfile()?.id ?? 0
    
    init(apiClient: NotificationsRequestsAPIClient = NotificationsRequestsAPIClient()) {
        self.APIClient = apiClient
    }
    
    //faq
    func getNotificationList(complete: @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0]
        
        if COMMON_SETTING.isConnectedToInternet() {
            IProgessHUD.show()
            
            APIClient.notificationsListAPI(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                if let data = response.data, data.count > 0
                {
                    self.notificationList = data
                    complete()
                }else{
                    if let message = response.message{
                        INotifications.show(message: message)
                    }
                }
            })
        }
    }
}
