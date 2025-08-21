//
//  ReadyMadeCell.swift
//  Customer
//
//  Created by webwerks on 10/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReadyMadeCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var qtyTxtFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var txtLabel1: UILabel!
    @IBOutlet weak var txtLabel2: UILabel!
    @IBOutlet weak var txtLabel3: UILabel!
    @IBOutlet weak var txtLabel4: UILabel!
    @IBOutlet weak var reviewItemBtn: ActionButton!
    @IBOutlet weak var reviewItemBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var checkBoxImgView: UIImageView!
    @IBOutlet weak var itemQuantityTxtField: CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ReadyMadeCell"
    }
    
}
