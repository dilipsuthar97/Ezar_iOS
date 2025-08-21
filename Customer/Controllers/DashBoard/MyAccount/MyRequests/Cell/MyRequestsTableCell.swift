//
//  MyRequestsTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 26/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MyRequestsTableCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!{
        didSet{
            profileImgView.layer.masksToBounds = true
            profileImgView.layer.cornerRadius = profileImgView.frame.width/2
        }
    }
    @IBOutlet weak var cancelButton: ActionButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        profileImgView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    class func cellIdentifier() -> String {
        return "MyRequestsTableCell"
    }
    
}
