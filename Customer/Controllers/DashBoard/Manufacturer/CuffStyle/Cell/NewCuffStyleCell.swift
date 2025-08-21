//
//  NewCuffStyleCell.swift
//  EZAR
//
//  Created by Ankita Firake on 22/07/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit
protocol CollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: CuffStyleCollectionCell?,
                        index: Int,
                        didTappedInTableViewCell: NewCuffStyleCell,
                        optionId:String,
                        mainListOptionId : String)

}

class NewCuffStyleCell: UITableViewCell {
    
    lazy var spacing: CGFloat = 10.0

    weak var cellDelegate: CollectionViewCellDelegate?
    var newListOption : ProductOption?
    var selectionIndex = 0
    var option_id = ""
    
    @IBOutlet weak var styleCollectionView: UICollectionView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        styleCollectionView.dataSource = self
        styleCollectionView.delegate = self
        let cellNib = UINib(nibName: "CuffStyleCollectionCell", bundle: nil)
        styleCollectionView.register(cellNib, forCellWithReuseIdentifier: "CuffStyleCollectionCell")
    }

    class func cellIdentifier() -> String {
        return "NewCuffStyleCell"
    }
    
    func setStyleData(optionsData:ProductOption) {
        newListOption = optionsData
        styleCollectionView.reloadData()
    }
}

extension NewCuffStyleCell: UICollectionViewDataSource,
                                UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView,
                       numberOfItemsInSection section: Int) -> Int {
       return newListOption?.values.count ?? 0
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuffStyleCollectionCell", for: indexPath as IndexPath) as? CuffStyleCollectionCell else {
           return UICollectionViewCell()
       }
       
       guard let productOptionValues = self.newListOption?.values[indexPath.row] else {
           return cell
       }
       option_id = productOptionValues.option_id
       cell.setupCell(productOptionValues)
       return cell
   }
   
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CuffStyleCollectionCell
        let newListOptionValue = newListOption?.values
        for (index,optionValue) in newListOptionValue!.enumerated() {
            if indexPath.row == index {
                optionValue.isChecked = true
            } else {
                optionValue.isChecked = false
            }
        }
        
        let option_Id = newListOption?.values[indexPath.row].option_id ?? ""
        selectionIndex = indexPath.row
        cellDelegate?.collectionView(collectionviewcell: cell, index: collectionView.tag, didTappedInTableViewCell: self,optionId: option_Id, mainListOptionId : newListOption?.main_option_id ?? "" )
        styleCollectionView.reloadData()
    }
    
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 230)
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return spacing
    }
}
