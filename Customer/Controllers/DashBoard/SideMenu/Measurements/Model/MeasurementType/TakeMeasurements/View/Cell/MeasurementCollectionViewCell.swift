//
//  SelfPracticeCollectionViewCell.swift
//  Thoab
//
//  Created by webwerks on 10/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import UIKit

class MeasurementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindViewModel()
    }
    
    class func cellIdentifier() -> String {
        return "MeasurementCollectionViewCell"
    }
    
//    var viewModel: CategoryData? {
//        didSet {
//            bindViewModel()
//        }
//    }
    
    private func bindViewModel() {
        self.imgView.image = #imageLiteral(resourceName: "logo")
    }
}
