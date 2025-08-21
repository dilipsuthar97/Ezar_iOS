//
//  NormalTableCell.swift
//  Customer
//
//  Created by webwerks on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class NormalTableCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellIdentifier() -> String {
        return "NormalTableCell"
    }
}
