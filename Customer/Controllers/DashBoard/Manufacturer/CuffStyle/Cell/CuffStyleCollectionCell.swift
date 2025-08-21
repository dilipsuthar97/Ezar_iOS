//
//  CuffStyleCollectionCell.swift
//  EZAR
//
//  Created by Ankita Firake on 23/07/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class CuffStyleCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cuffStyleImgView: UIImageView!
    @IBOutlet weak var cuffStyleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ data: ProductOptionValues) {
        cuffStyleTitle.text = data.title
        if data.isChecked {
            bgView.layer.borderWidth = 0
            gradientView.topColor = UIColor(named: "dark_gradient")!
            gradientView.bottomColor = UIColor(named: "light_gradient")!
        } else {
            bgView.layer.borderWidth = 2
            gradientView.topColor = .white
            gradientView.bottomColor = .white
        }
        
        if data.images_data.count > 0 {
            let imageUrl = data.images_data[0].url
            let encodedLink = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let encodedURL = NSURL(string: encodedLink!)! as URL
            cuffStyleImgView?.sd_setImage(with: encodedURL,
                                          placeholderImage: UIImage(named: "placeholder"),
                                          options: .continueInBackground,
                                          progress: nil,
                                          completed: nil)
        }
    }
}
