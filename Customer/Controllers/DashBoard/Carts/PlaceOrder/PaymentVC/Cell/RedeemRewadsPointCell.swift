//
//  RedeemRewadsPointCell.swift
//  Customer
//
//  Created by webwerks on 10/15/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class RedeemRewadsPointCell: UITableViewCell {

    @IBOutlet weak var rewardTitleLbl: UILabel!
    @IBOutlet weak var conversionTitleLbl: UILabel!
    @IBOutlet weak var rewardValueLbl: UILabel!
    @IBOutlet weak var conversionRateLbl: UILabel!
    @IBOutlet weak var useRewardsTxtField: CustomTextField!
    @IBOutlet weak var applyBtn: ActionButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rewardTitleLbl.text = TITLE.customer_rewardspoinsInWallet.localized
        self.conversionTitleLbl.text = TITLE.customer_conversationRate.localized
        useRewardsTxtField.addToolBar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "RedeemRewadsPointCell"
    }
    
}
