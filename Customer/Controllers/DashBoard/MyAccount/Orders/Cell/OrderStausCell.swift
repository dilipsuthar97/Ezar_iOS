//
//  OrderStausCell.swift
//  Customer
//
//  Created by webwerks on 10/23/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class OrderStausCell: UITableViewCell {

    @IBOutlet weak var imgViewOrderStatus: UIImageView!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblNoOfProducts: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var imgViewStatus: UIImageView!
    @IBOutlet weak var imgViewOrderStatusWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellIdentifier() -> String {
        return "OrderStausCell"
    }    
}
