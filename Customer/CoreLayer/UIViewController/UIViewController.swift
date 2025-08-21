//
//  UIViewController.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

// MARK: - UIViewController extenstion

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
    static func loadFromStoryBoard<T: UIViewController>(type: T.Type) -> T {
        var fullName: String = NSStringFromClass(T.self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let range = fullName.range(of:".", options:.backwards, range:nil, locale: nil){
            fullName = String(fullName[range.upperBound...])
        }
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: fullName) as? T else {
            return UIViewController() as! T
        }
        return vc
    }

    func delay(_ delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setTabBarIndex(index: Int) {
        APP_DELEGATE.tabBarController.selectedIndex = index
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Navigation Button
extension UIViewController {
    var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0.0
    }

    var navigationBarWithStatusBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (navigationController?.navigationBar.frame.height ?? 0.0)
    }

    func setNavigationBarHidden(hide: Bool = false) {
        navigationController?.navigationBar.isHidden = hide
        navigationController?.isNavigationBarHidden = hide
        navigationController?.setNavigationBarHidden(hide, animated: true)
    }

    func setLeftButton(title: String = "", isRoot: Bool = false) {
        let leftNavigationButton =  self.navigationItem.leftButton(title: title,
                                                                   imgName: "back_icon")
        leftNavigationButton.touchUp = { button in
            self.view.endEditing(true)
            if isRoot {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            self.dismiss(animated: true)
        }
    }

    
    func setCloseButton() {
        let leftNavigationButton = navigationItem.leftButton(imgName: "close_fill_icon")
        leftNavigationButton.touchUp = { _ in
            self.view.endEditing(true)
            self.dismiss(animated: true)
        }
    }
    
    func setHomeButton() {
        let leftNavigationButton =  self.navigationItem.leftButton(title: TITLE.Home,
                                                                   imgName: "")
        leftNavigationButton.touchUp = { button in
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
    }
}

