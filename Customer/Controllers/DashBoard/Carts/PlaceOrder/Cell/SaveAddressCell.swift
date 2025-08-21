//
//  SaveAddressCell.swift
//  Customer
//
//  Created by webwerks on 7/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SaveAddressCell: UITableViewCell {

    @IBOutlet weak var shadowview: ShaddowView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var removeAddressBtn: ActionButton!
    @IBOutlet weak var radioImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "SaveAddressCell"
    }
    
}
