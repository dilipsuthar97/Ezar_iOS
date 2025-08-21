//
//  ReqestInfoTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 28/08/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReqestInfoTableCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ReqestInfoTableCell"
    }
    
    
}
