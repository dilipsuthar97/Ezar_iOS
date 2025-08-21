//
//  MyReturnsVC.swift
//  Customer
//
//  Created by webwerks on 10/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MyReturnsVC: BaseTableViewController {

    var commentTxtView : UITextView = UITextView()
    var bottomView = ContainerView()
    var viewModel : MyReturnsViewModel = MyReturnsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReturnDetails()
        setupUI()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.return_Item.localized
    }
    
    func setupTableView() {
        
        //tableView.register(UINib(nibName: TailoreMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: TailoreMadeCell.cellIdentifier())
        tableView.register(UINib(nibName: ReadyMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReadyMadeCell.cellIdentifier())
        tableView.register(UINib(nibName: ChatCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ChatCell.cellIdentifier())
        tableView.register(UINib(nibName: DeliveryInstructionCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: DeliveryInstructionCell.cellIdentifier())
        let headerView = UINib.init(nibName: "SellerDetailHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "SellerDetailHeaderView")
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func getReturnDetails()
    {
        self.viewModel.returnDetails {
            if self.viewModel.responseCode == 200
            {
                self.tableView.reloadData()
            }
        }
    }
}

extension MyReturnsVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section
        {
        case 0:
            return self.viewModel.returnDetails?.items.count ?? 0
        case 1:
            return self.viewModel.returnDetails?.messages.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReadyMadeCell.cellIdentifier(), for: indexPath) as! ReadyMadeCell
            let item = self.viewModel.returnDetails?.items[indexPath.row]
            cell.reviewItemBtn.isHidden = true //Set False, if we want review Action
            cell.checkBoxImgView.isHidden = true //Set False, if we
            cell.reviewItemBtnHeight.constant = 0.0
            cell.reviewItemBtn.titleLabel?.text = ""
            cell.reviewViewHeight.constant = 0.0
            
            if let image = item?.image
            {
                let imageUrlString = URL.init(string: image)
                cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
            }
            cell.itemQuantityTxtField.isHidden = true
            cell.itemNameLbl.text = item?.name
            cell.priceLabel.text = String(format: "%@ %d", self.viewModel.returnDetails?.currency_symbol ?? "", item?.row_total ?? 0)
            self.setAttributedString(model: item!, cell: cell)
            
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier(), for: indexPath) as! ChatCell
            let message = self.viewModel.returnDetails?.messages[indexPath.row]
            cell.lblname.text = message?.from
            cell.lblcreatedAtDate.text = self.viewModel.returnDetails?.order_created_at
            cell.lblchat.text = message?.message
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryInstructionCell.cellIdentifier(), for: indexPath) as! DeliveryInstructionCell
            cell.textFieldName.text = TITLE.Comment.localized
            cell.sendBtn.isHidden = false
            cell.inputTextView.delegate = self
            cell.inputTextView.tag = indexPath.row
            cell.inputTextView.text = ""
            self.commentTxtView = cell.inputTextView
            cell.sendBtn.touchUp = { button in
                if !(self.commentTxtView.text.isEmpty)
                {
                    self.viewModel.message = self.commentTxtView.text
                    self.viewModel.submitComment {
                        if self.viewModel.responseCode == 200
                        {
                            self.getReturnDetails()
                        }
                    }
                }
                else
                {
                    INotifications.show(message: TITLE.customer_error_empty_message.localized)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SellerDetailHeaderView") as! SellerDetailHeaderView
        headerView.headerTitleLabel.textColor = Theme.blackColor
        headerView.headerTitleLabel.numberOfLines = 0
        headerView.headerTitleLabel.font = UIFont.init(customFont: CustomFont.FuturanHv, withSize: 11)
        headerView.headerTitleLabel.text = TITLE.Chat.localized
        return section == 1 ? headerView : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return section == 1 ? 40.0 : 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 235
        }
        else if indexPath.section == 2
        {
            return 195
        }
        return UITableView.automaticDimension
    }
    
    func setAttributedString(model : ReturnItemLists, cell : ReadyMadeCell)
    {
        if model.extra_info?.attributes_info.count == 0
        {
            cell.txtLabel4.isHidden = false
            cell.txtLabel4.text = "\(TITLE.customer_quantity_colon.localized) \(model.return_qty)"
            let arr = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count ?? 0 >= 3
        {
            cell.txtLabel1.isHidden = false
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel1.text = "\(TITLE.customer_quantity_colon.localized) \(model.return_qty)"
            let arr1 = cell.txtLabel1.text?.components(separatedBy: " ")
            cell.txtLabel1.addAttributeText(text: arr1![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel2.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr2 = cell.txtLabel2.text?.components(separatedBy: " ")
            cell.txtLabel2.addAttributeText(text: arr2![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel3.text = String(format: "%@: %@", model.extra_info?.attributes_info[1].label ?? "", model.extra_info?.attributes_info[1].value ?? "")
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[2].label ?? "", model.extra_info?.attributes_info[2].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count == 2
        {
            cell.txtLabel1.isHidden = true
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel2.text = "\(TITLE.customer_quantity_colon.localized) \(model.return_qty)"
            let arr2 = cell.txtLabel2.text?.components(separatedBy: " ")
            cell.txtLabel2.addAttributeText(text: arr2![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel3.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[1].label ?? "", model.extra_info?.attributes_info[1].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count == 1
        {
            cell.txtLabel1.isHidden = true
            cell.txtLabel2.isHidden = true
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel3.text = "\(TITLE.customer_quantity_colon.localized) \(model.return_qty)"
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
    }
}

extension MyReturnsVC : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTxtView = textView
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
