//
//  UserManager.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit
fileprivate let userDefaults = UserDefaults.standard

class LocalDataManager {

    static func setFirstTimeInstall(_isFirstTime: Bool) {
        userDefaults.set(_isFirstTime, forKey: "isFirstTimeInstall")
        userDefaults.synchronize()
    }
    
    static func getFirstTimeInstall() -> Bool {
        return userDefaults.bool(forKey: "isFirstTimeInstall")
    }
    
    static func setGuestUser(_isGuestUser: Bool) {
     userDefaults.set(_isGuestUser, forKey: "isGuestUser")
     userDefaults.synchronize()
    }
    
    static func getGuestUser() -> Bool {
        return userDefaults.bool(forKey: "isGuestUser")
    }
    
    //MARK: - User Location Enable - True / False
    static func setUserLocation(_ isAllow : Bool) {
        userDefaults.set(isAllow, forKey: "userLocation")
        userDefaults.synchronize()
    }
    
    static func getUserLocation() -> Bool {
        return userDefaults.bool(forKey: "userLocation")
    }
    
    
    //MARK: - User selection type - Custom made/ ready made
    static func setUserSelection(_ selection : String){
        userDefaults.set(selection, forKey: "productSelection")
        userDefaults.synchronize()
    }
    
    static func getUserSelection()-> String{
        if let selection = userDefaults.object(forKey: "productSelection") as? String {
            return selection
        } else {
            return ""
        }
    }
    
    //MARK: - Gender selection
    static func setGenderSelection(_ selection : Int){
        userDefaults.set(selection, forKey: "genderSelection")
        userDefaults.synchronize()
    }
    
    static func getGenderSelection()-> Int{
        if let selection = userDefaults.object(forKey: "genderSelection") as? Int {
            return selection
        }
        else{
            return GenderSelection.NONE.rawValue
        }
    }
    
    //MARK: - Set social user or normal user - used for change password show or not
    static func setSocialUser (_ isSocial : Bool) {
        userDefaults.set(isSocial, forKey: "isSocialUser")
        userDefaults.synchronize()
    }
    
    static func getIsSocialUser () -> Bool {
        if let isSocialUser = userDefaults.object(forKey: "isSocialUser") as? Bool {
            return isSocialUser
        } else {
            return false
        }
    }
    
    //MARK: - Language selection English / Arabic
    static func setSelectedLanguage(_ selection : Int){
        userDefaults.set(selection, forKey: "languageSelection")
        userDefaults.synchronize()
    }
    
    static func getSelectedLanguage()-> Int{
        if let selection = userDefaults.object(forKey: "languageSelection") as? Int {
            return selection
        } else {
            return 1
        }
    }
    
    //MARK: - Device Token
    static func setDeviceToken(_ deviceTokenValue : String){
        userDefaults.set(deviceTokenValue, forKey: "deviceToken")
        userDefaults.synchronize()
    }
    
    static func getDeviceToken()-> String{
        if let selection = userDefaults.object(forKey: "deviceToken") as? String {
            return selection
        } else {
            return ""
        }
    }
    
    //MARK: - IS Device Token Register
    static func setDeviceTokenRegister(_ isRegister : Bool) {
        userDefaults.set(isRegister, forKey: "isDeviceTokenRegister")
        userDefaults.synchronize()
    }
    
    static func getDeviceTokenRegister () -> Bool {
        if let isSocialUser = userDefaults.object(forKey: "isDeviceTokenRegister") as? Bool {
            return isSocialUser
        } else {
            return false
        }
    }
    
    //MARK: - IS Product type selection
    static func setProductTypeSelectionFlag (_ isProductType : Int) {
        userDefaults.set(isProductType, forKey: "isProductTypeSelectionAllowed")
        userDefaults.synchronize()
    }
    
    static func getProductTypeSelectionFlag () -> Int {
        if let selection = userDefaults.object(forKey: "isProductTypeSelectionAllowed") as? Int {
            return selection
        } else {
            return ProductTypeSelectionAllowed.NotAllowed.rawValue
        }
    }
    
    //MARK: - IS Gender selection
    static func setGenderSelectionFlag (_ isGenderSelection : Int) {
        userDefaults.set(isGenderSelection, forKey: "isGenderSelectionAllowed")
        userDefaults.synchronize()
    }
    
    static func getGenderSelectionFlag () -> Int {
        if let selection = userDefaults.object(forKey: "isGenderSelectionAllowed") as? Int {
            return selection
        } else {
            return GenderSelectionAllowed.NotAllowed.rawValue
        }
    }
    
    //MARK: - IS My Tailor Measurement Flag selection
    static func setMyTailorMeasurementFlag (_ isMyTailorMeasurement : Int) {
        userDefaults.set(isMyTailorMeasurement, forKey: "isMyTailorMeasurementAllowed")
        userDefaults.synchronize()
    }
    
    static func getMyTailorMeasurementFlag () -> Int {
        if let selection = userDefaults.object(forKey: "isMyTailorMeasurementAllowed") as? Int {
            return selection
        } else {
            return MyTailorMeasurementSelectionAllowed.NotAllowed.rawValue
        }
    }
    
    //MARK: - IS My Previous Measurement Flag selection
    static func setMyPreviousTailorMeasurementFlag (_ isMyPreviousMeasurement : Int) {
        userDefaults.set(isMyPreviousMeasurement, forKey: "isMyPreviousMeasurementAllowed")
        userDefaults.synchronize()
    }
    
    static func getMyPreviousTailorMeasurementFlag () -> Int {
        if let selection = userDefaults.object(
            forKey: "isMyPreviousMeasurementAllowed") as? Int {
            return selection
        } else {
            return MyPreviousMeasurementSelectionAllowed.NotAllowed.rawValue
        }
    }
    
    //MARK:- IS My Scan Body Measurement Flag selection
    static func setScanBodyMeasurementFlag (_ isScanBodyMeasurement : Int) {
        userDefaults.set(isScanBodyMeasurement, forKey: "isScanBodyMeasurementAllowed")
        userDefaults.synchronize()
    }
    
    static func getScanBodyMeasurementFlag () -> Int {
        if let selection = userDefaults.object(forKey: "isScanBodyMeasurementAllowed") as? Int {
            return selection
        } else {
            return ScanBodyMeasurementSelectionAllowed.NotAllowed.rawValue
        }
    }
    
    //MARK: - IS My Own Fabric Flag selection
    static func setMyOwnFabricSelectionFlag (_ isMyOwnFabric : Int) {
        userDefaults.set(isMyOwnFabric, forKey: "isMyOwnFabricAllowed")
        userDefaults.synchronize()
    }
    
    static func getMyOwnFabricSelectionFlag () -> Int {
        if let selection = userDefaults.object(forKey: "isMyOwnFabricAllowed") as? Int {
            return selection
        } else {
            return OwnFabricSelectionAllowed.NotAllowed.rawValue
        }
    }

    static func saveReferralCode(_ referralCode: String) {
        userDefaults.set(referralCode, forKey: "referral_code")
    }

    static func getReferralCode() -> String {
        guard let token = userDefaults.string(forKey: "referral_code") else {
            return ""
        }
        return token
    }
    
    static func saveInviteCode(_ inviteCode: String) {
        userDefaults.set(inviteCode, forKey: "invite_code")
    }

    static func getInviteCode() -> String? {
        guard let token = userDefaults.string(forKey: "invite_code") else {
            return nil
        }
        return token
    }
    
    static func removeInviteCode() {
        userDefaults.removeObject(forKey: "invite_code")
        userDefaults.synchronize()
    }
    
    static func saveShareLink(_ inviteCode: String) {
        userDefaults.set(inviteCode, forKey: "share_link")
    }

    static func getShareLink() -> String {
        guard let token = userDefaults.string(forKey: "share_link") else {
            return ""
        }
        return token
    }

}
