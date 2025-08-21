//
//  RewardHistoryTableViewCell.swift
//  EZAR
//
//  Created by Shruti Gupta on 3/12/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class RewardHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var transactiontypeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var createdAtLbl: UILabel!
    
    @IBOutlet weak var pointsTxtLbl: UILabel!
    @IBOutlet weak var transactiontypeTxtLbl: UILabel!
    @IBOutlet weak var descriptionTxtLbl: UILabel!
    @IBOutlet weak var balanceTxtLbl: UILabel!
    @IBOutlet weak var createdAtTxtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pointsTxtLbl.text = TITLE.rewardPoints.localized
        self.transactiontypeTxtLbl.text = TITLE.customer_transactionType.localized
        self.descriptionTxtLbl.text = TITLE.customer_description.localized
        self.balanceTxtLbl.text = TITLE.customer_balance.localized
        self.createdAtTxtLbl.text = TITLE.customer_created.localized
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier() -> String {
        return "RewardHistoryTableViewCell"
    }
}
