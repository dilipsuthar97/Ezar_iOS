//
//  ChatCell.swift
//  Customer
//
//  Created by webwerks on 10/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblcreatedAt: UILabel!
    @IBOutlet weak var lblcreatedAtDate: UILabel!
    @IBOutlet weak var lblchat: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String {
        return "ChatCell"
    }
    
}
