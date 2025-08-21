//
//  ImageIntroViewModel.swift
//  EZAR
//
//  Created by Shruti Gupta on 2/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class ImageIntroViewModel: NSObject {
    //setup UserViewModel that inherites from NSObject
    
    let APIClient : ImageIntroAPIClient
    
    var language    : String = ""
    var imageArray  : [List]?
    var status      : Bool?
    
    init(apiClient: ImageIntroAPIClient = ImageIntroAPIClient()) {
        self.APIClient = apiClient
    }
    
    //MARK:- image intro
    
    func getIntroImagesWS(complete:  @escaping isCompleted) {
        
        let params : NSMutableDictionary = [API_KEYS.language : language]
        
        if COMMON_SETTING.isConnectedToInternet() {
            
            IProgessHUD.show()
            
            APIClient.ImageIntroAPI(for: params, completionHandler: { (response) in
                IProgessHUD.dismiss()
                
                if let data = response.data
                {
                    if let list = data.list{
                        if list.count > 0
                        {
                            self.imageArray = list
                         
                        }
                    }
                }
                self.status = response.status
                complete()
            })
        }
    }
}
