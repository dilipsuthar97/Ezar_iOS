//
//  PaymentDoneVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 30/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup

protocol PaymentDoneVCDelegate{
    
    func onClickCloseInfoBtn()
}

class PaymentDoneVC: UIViewController {
    var delegate: PaymentDoneVCDelegate? = nil

    var placeOrderModel     : PlaceOrderModel?
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        self.contentSizeInPopup = CGSize(width: MAINSCREEN.width - 80, height: 380)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupController?.navigationBarHidden = true
        self.messageLabel.text = placeOrderModel?.message
        self.continueButton.setTitle(TITLE.ContinueShopping.localized, for: .normal)
    }

    @IBAction func onClickContinue(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onClickCloseInfoBtn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
