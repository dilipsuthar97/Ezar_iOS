//
//  ReturnVC.swift
//  Customer
//
//  Created by webwerks on 10/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReturnVC: BaseTableViewController {
    
    var order : CustomReadyMadeOrder? = nil
    var viewModel : orderDetails? = nil
    var commentTxtView : UITextView = UITextView()
    var bottomView = ContainerView()
    var returnViewModel : ReturnViewModel = ReturnViewModel()
    var checkBoxVisiblity : Bool = false
    
    //MARK: View Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setCustomBottomBar()
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
        navigationItem.title = TITLE.return_Item.localized
        setLeftButton()
    }
    
    //MARK:- Helpers for Custom Bottom Bar
    func setCustomBottomBar(){
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.Submit.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: TailoreMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: TailoreMadeCell.cellIdentifier())
        tableView.register(UINib(nibName: ReadyMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReadyMadeCell.cellIdentifier())
        tableView.register(UINib(nibName: DeliveryInstructionCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: DeliveryInstructionCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
}

extension ReturnVC : ButtonActionDelegate
{
    func onClickBottomButton(button: UIButton)
    {
        if checkBoxVisiblity == false{
            if commentTxtView.text.isEmpty
            {
                INotifications.show(message: TITLE.customer_error_empty_message.localized)
                return
            }
        }
        
        self.returnViewModel.order_id = self.viewModel?.order_id ?? 0
        self.returnViewModel.order_incremental_id = self.viewModel?.order_increment_id ?? 0
        self.returnViewModel.message = commentTxtView.text
        if self.viewModel?.items.count ?? 0 > 0
        {
            for (index, item) in (self.viewModel?.items.enumerated())!
            {
                var dictionary : AnyHashable?
                if item.isSeleced, item.returnQty > 0
                {
                    dictionary = ["item_id":item.order_item_id,"item_qty":item.returnQty]
                    self.returnViewModel.order_items.addEntries(from: ["\(index)":dictionary ?? ""])
                }
            }
        }
        
        
        if checkBoxVisiblity == false{
            if self.returnViewModel.order_items.count > 0
            {
                self.returnViewModel.returnItem {
                    if self.returnViewModel.isResponseSuccess
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                INotifications.show(message: TITLE.customer_product_select_msg.localized)
            }
        }else{
            INotifications.show(message: TITLE.customer_product_select_msg.localized)

        }
    }
}


extension ReturnVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel?.items.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let item = self.viewModel?.items[indexPath.row]
            if order?.group == "Tailors"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: TailoreMadeCell.cellIdentifier(), for: indexPath) as! TailoreMadeCell
                
                cell.reviewItemBtn.isHidden = true //Set False if we want review Action
                cell.reOrderBtn.isHidden = true
                cell.reviewItemBtnHeight.constant = 0.0
                cell.reviewItemBtn.titleLabel?.text = ""
                cell.reviewViewHeight.constant = 0.0
                if let image = item?.image
                {
                    let imageUrlString = URL.init(string: image)
                    cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                cell.itemNameLbl.text = item?.name
                cell.itemQuantityTxtField.isUserInteractionEnabled = false
                cell.itemQuantityTxtField.tag = indexPath.row
                cell.itemQuantityTxtField.delegate = self
                cell.itemQuantityTxtField.addToolBar()
                cell.itemQuantityTxtField.isHidden = false
                cell.itemQuantityTxtField.text = String(format: "%d", item?.returnQty ?? 0)
                cell.priceLabel.text = String(format: "%@ %d", self.viewModel?.currency_symbol ?? "", item?.row_total ?? 0)
                
                checkBoxVisiblity = false
                
               // cell.checkBoxImgView.image = item?.isSeleced ?? false ? UIImage(named : "checkbox_selected") : UIImage(named : "checkbox_unselected")
                if let returnRequest = item?.return_req_qty{
                    if returnRequest >= item?.qty_ordered ?? 0{
                        cell.checkBoxImgView.isHidden = true
                        cell.isUserInteractionEnabled = false
                        checkBoxVisiblity = true
                    }else{
                        cell.isUserInteractionEnabled = true
                        cell.checkBoxImgView.image = item?.isSeleced ?? false ? UIImage(named : "selectedicon") : UIImage(named : "unselected_icon")
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadyMadeCell.cellIdentifier(), for: indexPath) as! ReadyMadeCell
                cell.reviewItemBtn.isHidden = true //Set False if we want review Action
                cell.reviewItemBtnHeight.constant = 0.0
                cell.reviewItemBtn.titleLabel?.text = ""
                cell.reviewViewHeight.constant = 0.0
                if let image = item?.image
                {
                    let imageUrlString = URL.init(string: image)
                    cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                cell.itemQuantityTxtField.tag = indexPath.row
                cell.itemQuantityTxtField.isUserInteractionEnabled = false
                cell.itemQuantityTxtField.delegate = self
                cell.itemQuantityTxtField.isHidden = false
                cell.itemNameLbl.text = item?.name
                cell.priceLabel.text = String(format: "%@ %d", self.viewModel?.currency_symbol ?? "", item?.row_total ?? 0)
                self.setAttributedString(model: item!, cell: cell)
                
                checkBoxVisiblity = false
                
             //   cell.checkBoxImgView.image = item?.isSeleced ?? false ? UIImage(named : "checkbox_selected") : UIImage(named : "checkbox_unselected")
                
                if let returnRequest = item?.return_req_qty{
                    if returnRequest >= item?.qty_ordered ?? 0{
                        cell.checkBoxImgView.isHidden = true
                        checkBoxVisiblity = true
                         cell.isUserInteractionEnabled = false
                    }else{
                        cell.isUserInteractionEnabled = true
                        cell.checkBoxImgView.image = item?.isSeleced ?? false ? UIImage(named : "selectedicon") : UIImage(named : "unselected_icon")
                    }
                }
                
                cell.selectionStyle = .none
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryInstructionCell.cellIdentifier(), for: indexPath) as! DeliveryInstructionCell
            cell.textFieldName.text = TITLE.Comment.localized
            cell.inputTextView.delegate = self
            cell.inputTextView.tag = indexPath.row
            cell.inputTextView.text = ""
            self.commentTxtView = cell.inputTextView
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            for (index, item) in (self.viewModel?.items.enumerated())!
            {
                if index == indexPath.row
                {
                    self.viewModel?.items[index].isSeleced = item.isSeleced ? false : true
                    break
                }
            }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 235 : 195
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func setAttributedString(model : ItemList, cell : ReadyMadeCell)
    {
        cell.itemQuantityTxtField.text = String(format: "%d", model.returnQty)
        cell.itemQuantityTxtField.isUserInteractionEnabled = false
        if model.extra_info?.attributes_info.count == 0
        {
            cell.qtyTxtFieldTopConstraint.constant = cell.txtLabel4.frame.origin.y - (cell.txtLabel4.frame.size.height/2)
            cell.txtLabel4.isHidden = false
            cell.txtLabel4.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
            let arr = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count ?? 0 >= 3
        {
            cell.txtLabel1.isHidden = false
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.qtyTxtFieldTopConstraint.constant = cell.txtLabel1.frame.origin.y - (cell.txtLabel1.frame.size.height/2)
            cell.txtLabel1.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
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
            
            cell.qtyTxtFieldTopConstraint.constant = cell.txtLabel2.frame.origin.y - (cell.txtLabel2.frame.size.height/2)
            cell.txtLabel2.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
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
            
            cell.qtyTxtFieldTopConstraint.constant = cell.txtLabel3.frame.origin.y - (cell.txtLabel3.frame.size.height/2)
            cell.txtLabel3.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
    }
}

extension ReturnVC : UITextViewDelegate, UITextFieldDelegate
{
    //MARK :- UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let item = self.viewModel?.items[textField.tag]
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if(newString.isEmpty) {
            return true
        }
        
        //check if the string is a valid number
        let numberValue = Int(newString)
        
        if(numberValue == nil) {
            return false
        }
        let maxQty : Int = (item?.qty_shipped ?? 0) - (item?.qty_refunded ?? 0)
        
        if numberValue! > maxQty || maxQty == 0
        {
            INotifications.show(message: "\(TITLE.Max.localized) \(maxQty) \(TITLE.Quantity.localized)")
            return false
        }
        for (index, _) in (self.viewModel?.items.enumerated())!
        {
            if index == textField.tag
            {
                self.viewModel?.items[index].returnQty = numberValue ?? 0
                break
            }
        }
        return true
    }
    
    
    
    //MARK :- UITextViewDelegate Methods
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
