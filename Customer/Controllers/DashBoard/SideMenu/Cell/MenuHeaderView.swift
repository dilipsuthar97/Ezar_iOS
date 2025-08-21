//
//  MenuHeaderView.swift
//  Customer
//
//  Created by webwerks on 4/27/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MenuHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: ActionImageView!{
        didSet {
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = profileImage.frame.width/2
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!
}
