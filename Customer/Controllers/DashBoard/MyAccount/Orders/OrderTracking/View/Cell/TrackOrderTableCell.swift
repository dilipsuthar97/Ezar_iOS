//
//  TrackOrderTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 06/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//
//

import UIKit

class TrackOrderTableCell: UITableViewCell {

    @IBOutlet weak var orderStatusImage: UIImageView!
    @IBOutlet weak var needHelpBtn: ActionButton!
    @IBOutlet weak var cancelBtn: ActionButton!
    @IBOutlet weak var bgView: ShaddowView!
    @IBOutlet weak var pendingLbl: UILabel!
    @IBOutlet weak var processingLbl: UILabel!
    @IBOutlet weak var shippedLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var measurementView : UIView!
    @IBOutlet weak var updateMeasurementBtn: ActionButton!
    @IBOutlet weak var measurementViewHeightConstraint : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       COMMON_SETTING.configViewForRTL(view: self.bgView)
       COMMON_SETTING.setRTLforLabel(label: self.pendingLbl)
       COMMON_SETTING.setRTLforLabel(label: self.processingLbl)
       COMMON_SETTING.setRTLforLabel(label: self.shippedLbl)
       COMMON_SETTING.setRTLforLabel(label: self.deliveryLbl)
       COMMON_SETTING.setRTLforButton(button: self.needHelpBtn)
       COMMON_SETTING.setRTLforButton(button: self.cancelBtn)
    
        self.pendingLbl.text = TITLE.customer_pending.localized
        
        self.shippedLbl.text = TITLE.customer_track_status_shipped.localized
        
        self.needHelpBtn.setTitle(TITLE.customer_needHelp.localized, for: .normal)
        
        self.cancelBtn.setTitle(TITLE.customer_orderCancel.localized, for: .normal)
        
        updateMeasurementBtn.setTitle(TITLE.customer_updateMeasurement.localized, for: .normal)
        
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue {
            self.processingLbl.text = TITLE.customer_track_status_processing.localized
            self.deliveryLbl.text = TITLE.customer_delivered_status.localized
        }else{
            self.processingLbl.text = TITLE.customer_delivered_status.localized
            self.deliveryLbl.text = TITLE.customer_track_status_processing.localized
        }                          
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "TrackOrderTableCell"
    }
}
