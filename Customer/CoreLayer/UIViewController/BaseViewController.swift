//
//  BaseViewController.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import AVFoundation
import CoreLocation
import Material
import UIKit

class BaseViewController: UIViewController {
    var keyboardHandler: ((CGFloat, Double) -> Void)?

    // MARK: -View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        self.delay(0) {
            let n = KeyboardNotification(notification as NSNotification)
            let keyboardFrame = n.frameEndForView(view: self.view)
            let animationDuration = n.animationDuration
            self.keyboardHandler?(keyboardFrame.height, animationDuration)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.delay(0) {
            let n = KeyboardNotification(notification as NSNotification)
            let animationDuration = n.animationDuration
            self.keyboardHandler?(0, animationDuration)
        }
    }
    
    func onClickRightButton(button: UIButton) {
        // override to customize or write here the common behaviour
    }

    func onClickLeftButton(button: UIButton) {
        // override to customize or write here the common behaviour
    }
}

extension BaseViewController {

    func setBackButton(title: String = "") {
        let leftNavigationButton =  self.navigationItem.leftButton(title: title,
                                                                   imgName: "back_icon")
        leftNavigationButton.touchUp = { button in
            self.onClickLeftButton(button: button)
        }
    }
    
    func setRightButtonsArray(buttonArray: NSMutableArray) {
        let count : Int = buttonArray.count
        let buttonWidth = 40
        let rightView = UIView.init(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: buttonWidth * count,
                                                  height: 44))
        COMMON_SETTING.configViewForRTL(view: rightView)
        for index in 0 ..< count {
            let name : String = buttonArray[index] as! String
            let rightButton = navigationItem.rightButton(name: name)
            rightButton.frame = CGRect(x: (index * buttonWidth) +
                                       5,
                                       y: 5,
                                       width: buttonWidth,
                                       height: 35)
            rightButton.tag = index
            rightButton.touchUp = { button in
                self.onClickRightButton(button: rightButton)
            }
            rightView.addSubview(rightButton)
        }
        
        let rightItem:UIBarButtonItem = UIBarButtonItem(customView: rightView)
        navigationItem.rightBarButtonItem = rightItem
    }
        
    func setRightSearchButton() {
        let rightNavigationButton =  self.navigationItem.rightButton(name: "Search")
        rightNavigationButton.touchUp = { button in
            self.onClickRightButton(button: button)
        }
    }
    
    func setRightBarButton(title: String) {
        let rightNavigationButton =  self.navigationItem.rightButtonTitle(title: title)
        rightNavigationButton.touchUp = { button in
            self.onClickRightButton(button: button)
        }
    }
}
