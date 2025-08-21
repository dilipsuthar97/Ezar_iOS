//
//  ReviewTextCell.swift
//  Customer
//
//  Created by webwerks on 9/24/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewTextCell: UITableViewCell {

    @IBOutlet weak var textQuestion: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleTextField.addToolBar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ReviewTextCell"
    }
    
}
