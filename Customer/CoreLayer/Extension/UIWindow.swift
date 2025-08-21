//
//  UIWindow.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38_482_458_385
            let window = UIApplication.shared.windows.filter {
                $0.isKeyWindow
            }.first

            if let statusBar = window?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                statusBarView.tag = tag
                window?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }

    class func topViewController(controller: UIViewController? = APP_DELEGATE.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
