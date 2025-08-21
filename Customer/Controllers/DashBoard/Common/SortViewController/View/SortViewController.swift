//
//  SortViewController.swift
//  Customer
//
//  Created by Priyanka Jagtap on 28/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

protocol SortViewControllerDelegate : class {
    func getSelectedValue(orderBy: String , selectedIndex : Int)
    func getSelectedValueForSort(selectedValue: String, isCallApi : Bool ,selectedIndex : Int)
    
}


class SortViewController: BaseTableViewController {

    var bottomView = ContainerView()

    var options : [[String:String]] = [[:]]
    weak var delegate: SortViewControllerDelegate?
    
//    var options =  [["name":TITLE.PriceHighLow,"params" : "price_high_to_low"],["name":TITLE.PriceLowHigh,"params" : "price_low_to_high"],["name":TITLE.Popularity,"params" : "popularity"],["name":TITLE.Discount,"params" : "discount"],["name":TITLE.WhatsNew,"params" : "new"]]
    var selectedIndexpath : Int = -1
    var filterSortClassType : FilterSortClassType = .NONE
    var isProductsCategory = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        customBottonBar()
        if filterSortClassType == .NEARESTDELEGATEVC{
            options =  [["name":TITLE.customer_nameAZ,"params" : "name_low_to_high"],["name":TITLE.customer_nameZA,"params" : "name_high_to_low"],["name":TITLE.Favorite,"params" : "is_favourite"],["name":TITLE.customer_rating,"params" : "rating"]]
        }else if filterSortClassType == .MANUFACTURESARCHLISTVC{
            options =  [["name":TITLE.PriceHighLow,"params" : "price_high_to_low"],["name":TITLE.PriceLowHigh,"params" : "price_low_to_high"],["name":TITLE.Popularity,"params" : "popularity"],["name":TITLE.WhatsNew,"params" : "new"]]
        }else{
            if isProductsCategory == true{
                options = [["name":TITLE.customer_nameAZ,"params" : "name_low_to_high"],["name":TITLE.customer_nameZA]]
            }else{
               options = [["name":TITLE.PriceHighLow,"params" : "price_high_to_low"],["name":TITLE.PriceLowHigh,"params" : "price_low_to_high"],["name":TITLE.Discount,"params" : "discount"],["name":TITLE.WhatsNew,"params" : "new"]]
            }
        }
//        else {
//             options = [["name":TITLE.PriceHighLow,"params" : "price_high_to_low"],["name":TITLE.PriceLowHigh,"params" : "price_low_to_high"],["name":TITLE.Popularity,"params" : "popularity"],["name":TITLE.Discount,"params" : "discount"],["name":TITLE.WhatsNew,"params" : "new"]]
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.Sort.localized
        setRightBarButton(title: TITLE.ClearAll)
    }
    
    override func onClickLeftButton(button: UIButton) {
        if filterSortClassType == .PRODUCTSVC{
            self.dismiss(animated: true, completion: nil)
        }else{
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.Sort.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 55)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    
    func setupTableView() {
        tableView.register(UINib(nibName: SortTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SortTableCell.cellIdentifier())
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    //clear all action
    override func onClickRightButton(button: UIButton) {
        if filterSortClassType == .PRODUCTSVC{
            
             if isProductsCategory == true{
                selectedIndexpath = -1
                tableView.reloadData()
                //delegate?.getSelectedValue(orderBy: "", selectedIndex: -1)
                delegate?.getSelectedValueForSort(selectedValue: "", isCallApi: false, selectedIndex: -1)
                self.navigationController?.popViewController(animated: true)
             }else{
                selectedIndexpath = -1
                tableView.reloadData()
                delegate?.getSelectedValue(orderBy: "", selectedIndex: -1)
                self.navigationController?.popViewController(animated: true)
            }
            
        }else{
            selectedIndexpath = -1
            tableView.reloadData()
            self.navigateToParentViewController(orderBy: "")
        }
    }
}


//MARK:- TButton Action delegate method
extension SortViewController : ButtonActionDelegate {
    func onClickBottomButton(button: UIButton)
    {
        if filterSortClassType == .PRODUCTSVC{
            if selectedIndexpath >= 0
            {
                if isProductsCategory == true{

                    delegate?.getSelectedValueForSort(selectedValue: options[selectedIndexpath]["name"] ?? "", isCallApi: true, selectedIndex: self.selectedIndexpath)
                    
                }else{
                    let item = options[selectedIndexpath]
                    // self.navigateToParentViewController(orderBy: item["params"] ?? "")
                    delegate?.getSelectedValue(orderBy: item["params"] ?? "", selectedIndex: self.selectedIndexpath)
                    
                }
               
            self.navigationController?.popViewController(animated: true)
            }
            else{
                INotifications.show(message: TITLE.customer_option_selection.localized)
            }
        }else{
            if selectedIndexpath >= 0
            {
                let item = options[selectedIndexpath]
                self.navigateToParentViewController(orderBy: item["params"] ?? "")
            }
            else{
                INotifications.show(message: TITLE.customer_option_selection.localized)
            }
        }
    }
    
    func navigateToParentViewController(orderBy : String)
    {
        switch self.filterSortClassType
        {
        case .CHOOSEFABRICVC:
            let vc = COMMON_SETTING.popToAnyController(type: ChooseFabricVC.self, fromController: self)
            vc.viewModel.order_by = orderBy
            vc.isSortFilterApply = false
            vc.selectedSortIndex = self.selectedIndexpath
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .PRODUCTSVC:
            let vc = COMMON_SETTING.popToAnyController(type: ProductsVC.self, fromController: self)
            vc.viewModel.order_by = orderBy
            vc.selectedSortIndex = self.selectedIndexpath
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .NEARESTDELEGATEVC:
            let vc = COMMON_SETTING.popToAnyController(type: NearestDelegateVC.self, fromController: self)
            vc.viewModel.order_by = orderBy
            vc.selectedSortIndex = self.selectedIndexpath
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .CUFFSTYLEVC:
            let vc = COMMON_SETTING.popToAnyController(type: CuffStyleVC.self, fromController: self)
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .MANUFACTURESARCHLISTVC:
            let vc = COMMON_SETTING.popToAnyController(type: ManufacturerListVC.self, fromController: self)
            vc.searchViewModel?.order_by = orderBy
            vc.isSortFilterApply = true
            vc.selectedSortIndex = self.selectedIndexpath
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .TAILOREPRODUCTVC:
            let vc = COMMON_SETTING.popToAnyController(type: SearchVC.self, fromController: self)
            vc.viewModel.order_by = orderBy
            vc.selectedSortIndex = self.selectedIndexpath
            self.navigationController?.popToViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension SortViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortTableCell.cellIdentifier(), for: indexPath) as! SortTableCell
        cell.selectionStyle = .none
        
        cell.stateButton.touchUp = { button in
            if self.selectedIndexpath != indexPath.row
            {
                self.selectedIndexpath = indexPath.row
                tableView.reloadData()
            }
        }
        let item = options[indexPath.row]
        cell.titleLabel.text = item["name"]?.localized
        cell.stateButton.isSelected = false
        if selectedIndexpath == indexPath.row
        {
            cell.stateButton.isSelected = true
        }
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexpath != indexPath.row
        {
            selectedIndexpath = indexPath.row
            tableView.reloadData()
        }
    }
}
