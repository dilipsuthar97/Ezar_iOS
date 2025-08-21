//
//  OrderDetailTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 28/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class OrderDetailTableCell: UITableViewCell {

    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var totalOrderLbl: UILabel!
    @IBOutlet weak var deliveryTypeLbl: UILabel!
    @IBOutlet weak var totalPayableLbl: UILabel!
    @IBOutlet weak var orderDetailLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var payableLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.orderDetailLbl.text = TITLE.confirmDetails.localized
        self.orderLbl.text = TITLE.customer_total_order.localized
        self.deliveryLbl.text = TITLE.customer_delivery.localized
        self.payableLbl.text = TITLE.customer_total_payable.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "OrderDetailTableCell"
    }
}
