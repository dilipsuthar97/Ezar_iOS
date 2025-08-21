//
//  AddressTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 28/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class AddressTableCell: UITableViewCell {
    @IBOutlet weak var shadowView: ShaddowView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressTypeLbl: ActionButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var noteLblTitle: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var editAddress: ActionButton!
    @IBOutlet weak var addNewAddress: ActionButton!
    @IBOutlet weak var defaultLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "AddressTableCell"
    }
}
