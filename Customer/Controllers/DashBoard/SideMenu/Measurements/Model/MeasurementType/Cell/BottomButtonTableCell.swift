//
//  BottomButtonTableCell.swift
//  EZAR
//
//  Created by abc on 15/04/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit

class BottomButtonTableCell: UITableViewCell {

     @IBOutlet weak var titleTxtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier() -> String {
        return "BottomButtonTableCell"
    }
}
