//
//  IProgessHUD.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Alamofire
import Foundation
import SVProgressHUD

class IProgessHUD: NSObject {

    static func configure() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setBackgroundColor(UIColor(white: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setMinimumDismissTimeInterval(0.3)
    }
    
    static func show() {
        SVProgressHUD.show(withStatus: TITLE.loading.localized)
    }

    static func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    static func loaderError(_ text: String = "") {
        IProgessHUD.dismiss()
        SVProgressHUD.showError(withStatus: text)
    }
    
    static func loaderSuccess(_ text: String = "") {
        IProgessHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: text)
    }
}
