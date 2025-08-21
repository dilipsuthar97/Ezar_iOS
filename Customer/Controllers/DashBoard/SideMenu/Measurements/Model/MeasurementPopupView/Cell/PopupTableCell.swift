//
//  PopupTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 23/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class PopupTableCell: UITableViewCell {

    @IBOutlet weak var paramsLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "PopupTableCell"
    }
    
}
