 //
//  CommanSetting.swift
//  Thoab App
//
//  Created by Arvind Valaki on 08/01/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import Alamofire

let COMMON_SETTING = CommonSettings.sharedInstance
class CommonSettings: NSObject {

    var isRootViewController: Bool = true
    var orderIndex: Int = 0
    var favoriteIndex: Int = 0
    var manufacturerIndex: Int = 0

    var deliveryDate : String = ""
    var selectedDeliveryDate : String = ""
    var quantity : Int = 0
    var productType : String = ""
    var orderReview : Int?
    var vendorReview : Int?
    var delegateReview : Int?
    var delegateId : Int = 0
    var sellerId : String = ""
    var closeBtnTap : Bool = false
    var max_capacity : Int = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? 999 : 0
    var lang : String = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar"
    var isFromSellerRequest = false
    var name : String = ""
    var bodyHeight :String = ""
    var bodyWeight :String = ""
    var productIDScanBody : Int = 0
    var itemQuoteID = ""
    var selectType = ""
    var measurement_id = ""
    var isTailorMeasurement = false
    var backToM = false
    
    class var sharedInstance :CommonSettings {
        struct Singleton {
            static let instance = CommonSettings()
        }
        return Singleton.instance
    }
        
    func getTextFieldAligment(textField : UITextField) {
        if #available(iOS 9.0, *) {
            textField.semanticContentAttribute = COMMON_SETTING.getRTLOrLTRAligment()
        }
        textField.textAlignment = COMMON_SETTING.getRTLOrLTRTextAlignment()
    }
    
    @available(iOS 9.0, *)
    func getRTLOrLTRAligment() -> UISemanticContentAttribute {
        return LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? .forceLeftToRight : .forceRightToLeft
    }
    
    func getRTLOrLTRTextAlignment() -> NSTextAlignment {
        return LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? .left : .right
    }
    
    func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while (topController.presentedViewController != nil) {
                topController = topController.presentedViewController!
            }
            return topController
        }
        return nil
    }
    
    func timeInterval(timeAgo:String) -> String {
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        let df = DateFormatter()
        
        df.dateFormat = dateFormat
        df.timeZone = TimeZone(abbreviation: "                     ")
        let dateWithTime = df.date(from: timeAgo)
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateWithTime!, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" : "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" : "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" : "\(day)" + " " + "days ago"
        }else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" : "\(hour)" + " " + "hours ago"
        }else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago" : "\(minute)" + " " + "minutes ago"
        }else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second ago" : "\(second)" + " " + "seconds ago"
        } else {
            return "a moment ago"
            
        }
    }

    //MARK: - Date & strings conversions
    func getStringDate(withDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        dateFormatter.locale = Locale.init(identifier: LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar")
        return dateFormatter.string(from: withDate)
        
    }
    
    //MARK: - Date & strings conversions
    func getStringDate(withDate: Date, formate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.locale = Locale.init(identifier: LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar")
        return dateFormatter.string(from: withDate)
        
    }
    
    //MARK: - Date & strings conversions
    func getEnglishStringDate(withDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        dateFormatter.locale = Locale.init(identifier: "en")
        return dateFormatter.string(from: withDate)
    }
    
    func getDateFormString(withString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate //Your date format
        dateFormatter.locale = Locale.init(identifier: LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar")
        //dateFormatter.locale = Locale.init(identifier: "en")
        return dateFormatter.date(from: withString) ?? Date() //according to date format your date string
    }
            
     func popToAnyController<T: UIViewController>(type: T.Type,
                                                  fromController : UIViewController) -> T {
        var toController : UIViewController = UIViewController()
       
         for controller in (fromController.navigationController?.children)! {
            if controller is T {
                toController = controller
                break
            }
        }
        return toController as! T
     }
    
    //MARK: - Check internet connection
    func isConnectedToInternet() -> Bool {
        if NetworkReachabilityManager()!.isReachable {
            return true
        } else {
            INotifications.show(message: MESSAGE.noInternet.localized, type: .error)
            return false
        }
    }
    
    func showAlertMessage(_ title:String, message:String, currentVC:UIViewController ) -> Void {
        let alert = UIAlertController(title: title as String, message:message as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
        DispatchQueue.main.async(execute: {
            currentVC.present(alert, animated: true, completion: nil)
        })
    }
    
    func showAlertControllerWithAction(title : String ,message:String,leftTitle : String? = nil,rightTitle : String? = nil,okAction:(()->())? = nil ,cancelAction:(()->())? = nil,currentController: UIViewController ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let leftTitle = leftTitle{
            let positive = UIAlertAction(title: leftTitle , style: .default, handler: {(_ action: UIAlertAction) -> Void in
                okAction?()
            })
            alert.addAction(positive)
        }
        
        if let rightTitle = rightTitle{
            let negative = UIAlertAction(title: rightTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                cancelAction?()
            })
            alert.addAction(negative)
        }
        
        if leftTitle == nil, rightTitle == nil {
            let defaultAction = UIAlertAction(title: "Ok".localized, style: .default, handler:  {(_ action: UIAlertAction) -> Void in
                okAction?()
            })
            alert.addAction(defaultAction)
        }
       currentController.present(alert, animated: true, completion: nil)
    }
    
    func getTheStarRatingValue(rating : String) -> CGFloat {
        var ratingValue : CGFloat = 0.0
        if let stringToFloat = Float(rating){
            ratingValue = CGFloat(stringToFloat)
        }
        return ratingValue
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func addToWishListParameters(_ product_id : Int, category_name : String, style : String, qty : Int, price : String, special_price : String, delivery_date : String, item_quote_id : String, quote_id : String, avlOptionArray : [[String : String]], category_id : Int, is_promotion : Int) -> NSMutableDictionary
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.id ?? 0,
                                            API_KEYS.product_id : product_id,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.qty : qty,
                                            API_KEYS.category_name : category_name,
                                            API_KEYS.price : price,
                                            API_KEYS.special_price : special_price,
                                            API_KEYS.delivery_date : delivery_date,
                                            API_KEYS.category_id : category_id,
                                            API_KEYS.is_promotion : is_promotion]
        
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue
        {
            params.addEntries(from: [API_KEYS.style : style,
                                     API_KEYS.item_quote_id : item_quote_id])
        }
        else
        {
            params.addEntries(from: [API_KEYS.quote_id : quote_id])
            for dictionary in avlOptionArray
            {
                params.addEntries(from: dictionary)
            }
        }
        return params
    }
    
    
    func addToWishListParametersForDelegate(_ product_id : Int, category_name : String, style : String, qty : Int, price : String, special_price : String, delivery_date : String, item_quote_id : String, quote_id : String, avlOptionArray : [[String : String]], category_id : Int, is_promotion : Int) -> NSMutableDictionary
    {
        let params : NSMutableDictionary = [API_KEYS.customer_id : Profile.loadProfile()?.customerId ?? 0,
                                            API_KEYS.product_id : product_id,
                                            API_KEYS.product_type : LocalDataManager.getUserSelection(),
                                            API_KEYS.qty : qty,
                                            API_KEYS.category_name : category_name,
                                            API_KEYS.price : price,
                                            API_KEYS.special_price : special_price,
                                            API_KEYS.delivery_date : delivery_date,
                                            API_KEYS.category_id : category_id,
                                            API_KEYS.is_promotion : is_promotion]
        
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue
        {
            params.addEntries(from: [API_KEYS.style : style,
                                     API_KEYS.item_quote_id : item_quote_id])
        }
        else
        {
            params.addEntries(from: [API_KEYS.quote_id : quote_id])
            for dictionary in avlOptionArray
            {
                params.addEntries(from: dictionary)
            }
        }
        return params
    }
    
    func configScrollViewForRTL(scrollView : UIScrollView){
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            scrollView.transform = CGAffineTransform(scaleX:-1,y: 1);
        }else{
            scrollView.transform = CGAffineTransform(scaleX: 1,y: 1);
        }
    }
    
    func configImageViewForRTL(imageView : UIImageView){
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            imageView.transform = CGAffineTransform(scaleX:-1,y: 1);
        }else{
            imageView.transform = CGAffineTransform(scaleX: 1,y: 1);
        }
    }
    
    func configViewForRTL(view: UIView){
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            view.transform = CGAffineTransform(scaleX:-1,y: 1);
        }else{
            view.transform = CGAffineTransform(scaleX: 1,y: 1);
        }
    }
    
    func setRTLforTextField(textField : CustomTextField){
       if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
           // textField.textAlignment = .right
        
            textField.paddingLeft = 10
            textField.paddingRight = 60
        }else{
           // textField.textAlignment = .left
            textField.paddingLeft = 40
            textField.paddingRight = 10
        }
    }
    
    func setRTLforLabel(label : UILabel){
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            label.transform = CGAffineTransform(scaleX:-1,y: 1);
        }else{
            label.transform = CGAffineTransform(scaleX: 1,y: 1);
        }
    }
    
    func setRTLforLabelDirection(label : UILabel){
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            label.textAlignment = .right
        }else{
             label.textAlignment = .left
        }
    }
    
    func setRTLforButton(button : UIButton){
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            button.transform = CGAffineTransform(scaleX:-1,y: 1);
        }else{
            button.transform = CGAffineTransform(scaleX: 1,y: 1);
        }
    }
    
    func showAlertController(icon:UIImage?, title: String, message: String) {
        let alert = EMAlertController(icon: icon, title: title, message: message)
        let action1 = EMAlertAction(title: "Ok".localized, style: .defults)
        alert.isSingleButton = true
        alert.addAction(action: action1)
        (APP_DELEGATE.window?.rootViewController)?.present(alert, animated: true, completion: nil)
    }
}
