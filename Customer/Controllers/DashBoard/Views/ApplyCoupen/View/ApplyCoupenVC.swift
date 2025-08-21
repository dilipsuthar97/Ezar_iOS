//
//  ApplyCoupenVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 09/10/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ApplyCoupenVC: BaseViewController {

    @IBOutlet weak var coupenCodeTxtField: CustomTextField!
    @IBOutlet weak var ApplyBtn: ActionButton!
    
    //MARK : View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupValidations()
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.ApplyCoupon.localized
        setRightBarButton(title: TITLE.cancel)
        coupenCodeTxtField.placeholder = TITLE.customer_coupon_code.localized
    }
    
    func setupValidations() {
        coupenCodeTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  TITLE.customer_coupon_empty_message.localized, EmptyMessage: TITLE.customer_coupon_empty_message.localized))
    }
}

