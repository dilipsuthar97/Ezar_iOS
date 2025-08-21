//
//  DynamaticLinkVC.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import FirebaseDynamicLinks
import UIKit

let deepLinkURLScheme = "com.alnaseej.Customer"
let domainURIPrefix = "https://ezarksa.page.link"

let androidPackageName = "thobe.alnaseej.alnaseejthobe"
let fallBackURL = "https://onelink.to/2f52yf"
let logoImg = "https://ezarksa.com/pub/media/logo/stores/2/ezar_logo_live.png"

class DynamicLinkData: NSObject {
    var inviteCode: String?

    override init() {
        super.init()
    }
}

class DynamaticLinkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func createComponets() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "ezarksa"
        components.path = "/invite"
        return components
    }

    func shareInviteLink(inviteCode: String,
                         completionHandler: @escaping JSONCompletionHandler) {
        var components = createComponets()
        let inviteCode = URLQueryItem(name: "invite_code",
                                      value: String(inviteCode))
        components.queryItems = [inviteCode]

        guard let linkParameter = components.url else {
            return
        }

        print("I am sharing \(linkParameter.absoluteString)")
        guard let sharLink = DynamicLinkComponents(link: linkParameter,
                                                   domainURIPrefix: domainURIPrefix) else {
            print("couldn't create FDL componets")
            return
        }

        sharLink.options?.pathLength = .short
        sharLink.navigationInfoParameters?.isForcedRedirectEnabled = false

        if let bundleId = Bundle.main.bundleIdentifier {
            sharLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleId)
        }
        sharLink.iOSParameters?.appStoreID = "1450373696"
        sharLink.androidParameters = DynamicLinkAndroidParameters(packageName: androidPackageName)
    
        sharLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharLink.socialMetaTagParameters?.title = "EZAR"
        sharLink.socialMetaTagParameters?.descriptionText = "Share your referral link with your friends, and family and introduce them to the eZAR along with the chance to get rewards!"
        sharLink.socialMetaTagParameters?.imageURL = URL(string: logoImg)

        guard let longURL = sharLink.url else {
            return
        }
        print("LONG URL: \(longURL.absoluteString)")
        IProgessHUD.show()
        sharLink.shorten { url, warnings, error in
            IProgessHUD.dismiss()
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("FDL Warnings: \(warning)")
                }
                return
            }
            
            guard let url = url else {
                return
            }
            completionHandler("\(url.absoluteURL)")
        }
    }
}

// MARK: - URL queryItems

extension URL {
    func value(for paramater: String) -> String? {
        let queryItems = URLComponents(string: absoluteString)?.queryItems
        let queryItem = queryItems?.filter {
            $0.name == paramater
        }.first
        let value = queryItem?.value
        return value
    }
}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}

