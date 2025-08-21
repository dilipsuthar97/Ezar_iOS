//
//  FilterTableViewCell.swift
//  Customer
//
//  Created by webwerks on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    var viewModel: Buyer? {
//        didSet {
//            bindViewModel()
//        }
//    }

    class func cellIdentifier() -> String {
        return "FilterTableViewCell"
    }
    
    private func bindViewModel() {
//        self.AgentNameLbl?.text = viewModel?.buyer_name
//        self.mobileNoLbl?.text = viewModel?.buyer_phone
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
