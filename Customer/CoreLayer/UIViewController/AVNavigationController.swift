//
//  GISNavigationController.swift
//  GIS-Agent
//
//  Created by Arvind Valaki on 08/01/18.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import UIKit

let NAVIGATION = AVNavigationController.sharedInstance

open class AVNavigationController: UINavigationController {
    
    class var sharedInstance :AVNavigationController {
        struct Singleton {
            static let instance = AVNavigationController()
        }
        return Singleton.instance
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = false
        navigationAppearance(color: Theme.white)
        statusBarColor(color: Theme.white)
        changeNavBG(name: "Nav_BG")
        addShadowView()
    }
    
    func navigationAppearance(color: UIColor = .clear) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(customFont: CustomFont.FuturanM, withSize: 18) ?? UIFont.boldSystemFont(ofSize: 20)]
        navBarAppearance.backgroundColor = color
        navBarAppearance.backgroundImage = UIImage.imageWithColor(color: color)
        navBarAppearance.shadowImage = UIImage.imageWithColor(color: color)
        navigationBar.isTranslucent = true
        navigationBar.tintColor = Theme.darkGray

        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.setNeedsLayout()
        navigationBar.layoutIfNeeded()
        navigationBar.setNeedsDisplay()
    }

    func statusBarColor(color: UIColor = .clear) {
        UIApplication.shared.statusBarView?.backgroundColor = color
        UINavigationBar.appearance().frame = CGRect(x: 0, y: 0,
                                                    width: (APP_DELEGATE.window?.frame.size.width)!,
                                                    height: (APP_DELEGATE.window?.frame.size.height)!)
        navigationBar.setNeedsLayout()
        navigationBar.layoutIfNeeded()
        navigationBar.setNeedsDisplay()
    }
    
    
    func changeNavBG(name: String) {
        let navBackgroundImage = UIImage(named: name)
        self.navigationBar.setBackgroundImage(navBackgroundImage?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
    }
    
    func clearNavigationBackground() {
        let navBackgroundImage = UIImage()
        self.navigationBar.setBackgroundImage(navBackgroundImage, for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}

extension UINavigationController {
    
    func addShadowView() {
        navigationBar.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        navigationBar.layer.shadowRadius = 1.0
        navigationBar.layer.shadowOpacity = 0.2
        navigationBar.layer.masksToBounds = false
    }
    
    func removedShadowView() {
        self.navigationBar.layer.shadowColor    = UIColor.clear.cgColor
        self.navigationBar.layer.shadowOffset   = CGSize(width: 0.0, height:1.0)
        self.navigationBar.layer.shadowRadius   = 1.0
        self.navigationBar.layer.shadowOpacity  = 0.2
        self.navigationBar.layer.masksToBounds  = false
        
    }
    
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
    func jumpToViewController(index : Int? = nil) {
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(index!) // views to pop
        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
}


