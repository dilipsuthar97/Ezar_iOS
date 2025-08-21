//
//  DeliveryDateTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 28/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class DeliveryDateTableCell: UITableViewCell {

    @IBOutlet weak var deliveryTitle: UILabel!
    @IBOutlet weak var deliveryDetailLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        COMMON_SETTING.configImageViewForRTL(imageView: imgView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "DeliveryDateTableCell"
    }
}
