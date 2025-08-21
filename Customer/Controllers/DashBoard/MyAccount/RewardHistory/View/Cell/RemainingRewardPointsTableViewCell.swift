//
//  RemainingRewardPointsTableViewCell.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/23/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class RemainingRewardPointsTableViewCell: UITableViewCell {

    @IBOutlet weak var rewardsPointsTxtLbl: UILabel!
    @IBOutlet weak var rewardsPointsValLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rewardsPointsTxtLbl.text = TITLE.customer_remaining_reward_points.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier() -> String {
        return "RemainingRewardPointsTableViewCell"
    }
}
