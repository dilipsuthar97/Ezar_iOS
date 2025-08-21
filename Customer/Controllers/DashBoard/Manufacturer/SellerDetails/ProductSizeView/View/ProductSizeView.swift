//
//  ProductSizeView.swift
//  Customer
//
//  Created by webwerks on 4/18/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import SDWebImage
import STPopup

protocol ProductSizeViewDelegate
{
    func updateButtonClick(selectedOptionArray : [[String : String]])
}

class ProductSizeView: UIView {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var cancelBtn: ActionButton!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var sizeChartView: UIView!
    var delegate : ProductSizeViewDelegate!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sizeChartBtn: ActionButton!
    @IBOutlet weak var imgView: UIImageView!
    var bottomView = ContainerView()
    var viewModel : SellerViewModel = SellerViewModel()
    var selectedOptionArray : [[String : String]] = []
    var firstCellValue : String = ""
    var secondCellValue : String = ""

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.width, height: MAINSCREEN.height)
        
        sizeChartBtn.setTitle(TITLE.customer_size_chart.localized, for: .normal)
        sizeChartBtn?.touchUp = { button in
           
          if let item = self.viewModel.vendorDetail,!item.sizechart.isEmpty{
            self.bottomView.isHidden = true
             self.sizeChartView.isHidden = false
                self.webView.loadHTMLString(item.sizechart, baseURL: nil)
            }else{
                INotifications.show(message: TITLE.product_info_not_available.localized)
            }
        }
        
        cancelBtn?.touchUp = { button in
            self.sizeChartView.isHidden = true
            self.bottomView.isHidden = false

        }
    }
  
    //MARK:- Helpers for data & UI
    func setUpUpdateButton()
    {
        self.resetAllSelection()
        var buttonArray : NSMutableArray = []
        buttonArray = [TITLE.done.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.addSubview(self.bottomView)
    }
    
    func resetAllSelection()
    {
        for (input, _) in (self.viewModel.vendorDetail?.all_options.enumerated())!
        {
            for (index, _) in (self.viewModel.vendorDetail?.all_options[input].options.enumerated())!
            {
                if self.viewModel.attributesInfo.count == 0
                {
                    self.viewModel.vendorDetail?.all_options[input].options[index].isAllDisable = input == 0 ? false : true
                    self.viewModel.vendorDetail?.all_options[input].options[index].isSelected = false
                }
                else
                {
                    self.viewModel.vendorDetail?.all_options[input].options[index].isAllDisable = false
                }
            }
        }
    }
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        tableView.register(UINib(nibName: ProductSizeTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ProductSizeTableCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK:- Bottom Action Button Delegate Method
extension ProductSizeView : ButtonActionDelegate
{
    func onClickBottomButton(button: UIButton) {
      
        if (self.selectedOptionArray.count > 0) && (self.selectedOptionArray.count == self.viewModel.vendorDetail!.all_options.count)
        {
            self.delegate.updateButtonClick(selectedOptionArray: self.selectedOptionArray)
        }
        else
        {
            INotifications.show(message: TITLE.customer_size_chart_na.localized)
        }
       
    }
}

//MARK:- UITable Delegate & DataSource
extension ProductSizeView : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //backViewHeight.constant = self.viewModel.vendorDetail?.all_options.count == 1 ? 180.0 : 270.0
        backViewHeight.constant = 220.0 + self.returnHeightConstant(count: (self.viewModel.vendorDetail?.all_options.count) ?? 0)
        return self.viewModel.vendorDetail!.all_options.count
    }
    
    func returnHeightConstant(count : Int) -> CGFloat
    {
        var heightConstant = 180.0
        if count > 1
        {
            for _ in 1..<count
            {
                heightConstant = heightConstant + 90
            }
        }
        return CGFloat(heightConstant)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductSizeTableCell.cellIdentifier(), for: indexPath) as! ProductSizeTableCell
        cell.selectionStyle = .none
        let allOptions = self.viewModel.vendorDetail?.all_options[indexPath.row]
        cell.titleTxt.text = allOptions?.option_name
        cell.collectionView.tag = indexPath.row
        if cell.collectionView.delegate != nil
        {
            cell.collectionView.delegate = nil
            cell.collectionView.dataSource = nil
        }
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ProductSizeView : UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel.vendorDetail!.all_options[collectionView.tag].options.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductSizeCCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSizeCCell.cellIdentifier(), for: indexPath as IndexPath) as! ProductSizeCCell
        let allOptions = self.viewModel.vendorDetail?.all_options[collectionView.tag]
        let subOptions = allOptions?.options[indexPath.row]
        
        print((subOptions?.isSelected)!)
        cell.backGView.isHidden = !((subOptions?.isSelected)!)
        
        cell.sizeLabel.text = subOptions?.label
        cell.sizeLabel.isHidden = false
        let rgbValue = (subOptions?.color.replacingOccurrences(of: "#", with: "0x"))
        
        if (subOptions?.isDisable)!
        {
           cell.selectedView.alpha = 0.2
            
        }
        else
        {
            cell.selectedView.alpha = 1.0
            cell.selectedView.image = UIImage.init()
            if !((rgbValue?.isEmpty) ?? false), !((subOptions?.isDisable)!)
            {
                cell.sizeLabel.isHidden = true
                cell.selectedView.image = UIImage.init(color: UIColor(hex: rgbValue ?? "0x000000"))
            }
            else if let image = subOptions?.image, !((subOptions?.isDisable)!), !(image.isEmpty)
            {
                cell.sizeLabel.isHidden = true
                let imageUrlString = URL.init(string: image)
                cell.selectedView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
            }
        }
        
        
        cell.noAvailableView.isHidden = (subOptions?.isDisable)! ? false : true
        
        
        if (subOptions?.isAllDisable) ?? false
        {
            cell.selectedView.alpha = 0.2
        }
        cell.layoutIfNeeded()
        if (subOptions?.isSelected)!
        {
            self.setSelectedOptionArray(allOptions: allOptions!, subOptions: subOptions!)
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let allOptions = self.viewModel.vendorDetail?.all_options[collectionView.tag]
        let subOptions = allOptions?.options[indexPath.row]
        if (subOptions?.isDisable) ?? false
        {
            return
        }
        
        for (index, _) in (self.self.viewModel.vendorDetail?.all_options[collectionView.tag].options.enumerated())! {
            
            if !((self.viewModel.vendorDetail?.all_options[collectionView.tag].options[index].isDisable)!){
                
                let isSelected : Bool = indexPath.row == index ? true : false
                self.viewModel.vendorDetail?.all_options[collectionView.tag].options[index].isSelected = isSelected
                if isSelected
                {
                    self.imgView.image = UIImage.init(named: "placeholder")
                    if collectionView.tag == 0
                    {
                        firstCellValue = (self.viewModel.vendorDetail?.all_options[collectionView.tag].options[index].label) ?? ""
                        secondCellValue = ""
                        self.selectedOptionArray.removeAll()
                    }
                    else if collectionView.tag == 1
                    {
                        secondCellValue = (self.viewModel.vendorDetail?.all_options[collectionView.tag].options[index].label) ?? ""
                    }
                    
                    if collectionView.tag + 1 == self.viewModel.vendorDetail?.all_options.count, !(secondCellValue.isEmpty)
                    {
                        if let imageUrl = self.viewModel.vendorDetail?.all_options[collectionView.tag].options[index].imageUrl
                        {
                            let imageUrlString = URL.init(string: imageUrl)
                            self.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                        }
                    }
                }
            }
        }
        self.disableinCombination(input: collectionView.tag + 1, key : firstCellValue+secondCellValue)
        tableView.reloadData()
    }
    
    func disableinCombination(input : Int, key : String)
    {
        self.resetAllSelectionOfLast(input: input)
        if input < (self.viewModel.vendorDetail?.all_options.count) ?? 0
        {
            for (count, _) in (self.viewModel.vendorDetail?.all_options.enumerated())!
            {
                if count >= input
                {
                    for (index, _) in (self.viewModel.vendorDetail?.all_options[count].options.enumerated())!
                    {
                        for value in self.viewModel.finalAvlArray
                        {
                            let vv : String = (self.viewModel.vendorDetail?.all_options[count].options[index].label) ?? ""
                            let avlValue : String = (value.value(forKey: key) as? String) ?? ""
                            if avlValue == vv
                            {
                                self.viewModel.vendorDetail?.all_options[count].options[index].isAllDisable = false
                                self.viewModel.vendorDetail?.all_options[count].options[index].isSelected = false
                               
                                let image : String = (value.value(forKey: avlValue) as? String) ?? ""
                                self.viewModel.vendorDetail?.all_options[count].options[index].imageUrl = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    func resetAllSelectionOfLast(input : Int)
    {
        if input < (self.viewModel.vendorDetail?.all_options.count) ?? 0
        {
            for (count, _) in (self.viewModel.vendorDetail?.all_options.enumerated())!
            {
                if count >= input
                {
                    for (index, _) in (self.viewModel.vendorDetail?.all_options[count].options.enumerated())!
                    {
                        self.viewModel.vendorDetail?.all_options[count].options[index].isAllDisable = true
                        self.viewModel.vendorDetail?.all_options[count].options[index].isSelected = false
                    }
                }
            }
        }
    }
    
    
    func setSelectedOptionArray(allOptions : AllOPtions, subOptions : SubOPtions)
    {
        let key : String = allOptions.attribute_id
        let value : String = subOptions.value
        let formatedKey : String = "super_attribute[\(key)]"
        let dictionary : [String : String] = [formatedKey:value]
        for (index, dict) in self.selectedOptionArray.enumerated()
        {
            if dict[formatedKey] != nil
            {
                self.selectedOptionArray.remove(at: index)
            }
        }
        self.selectedOptionArray.append(dictionary)
    }
}


