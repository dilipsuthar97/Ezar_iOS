//
//  NearestDelegateVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 12/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class NearestDelegateVC: BaseViewController {

    let viewModel : NearestDelegateViewModel = NearestDelegateViewModel()
    var isFromSellerDetailRequest = false
     var selectedSortIndex : Int = -1
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        getNearestDelegateList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNearestDelegateList()
    }
    
    func getNearestDelegateList()
    {
        self.viewModel.getNearestDelegateList {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
   
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.nearestDelegate.localized
        setRightButtonsArray(buttonArray: ["sortW_Icon"])
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ManufacturerCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ManufacturerCell.cellIdentifier())
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
    }
    
    override func onClickRightButton(button: UIButton)
    {
        if button.tag == 0
        {
            let vc : SortViewController  = SortViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            vc.filterSortClassType = .NEARESTDELEGATEVC
             vc.selectedIndexpath = self.selectedSortIndex
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NearestDelegateVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.delegateList.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManufacturerCell.cellIdentifier(), for: indexPath) as! ManufacturerCell
        cell.selectionStyle = .none
        cell.reset()
        
        let delegateModel = self.viewModel.delegateList[indexPath.section]
        
        if  !delegateModel.commission_charge.isEmpty &&  !delegateModel.currency_symbol.isEmpty{

            if delegateModel.commission_type == 0{
                cell.statusLbl.text = delegateModel.currency_symbol + " " + delegateModel.commission_charge + " " + TITLE.customer_perPiece.localized
            }else{
                cell.statusLbl.text = delegateModel.currency_symbol + " " + delegateModel.commission_charge + " " + TITLE.customer_perOrder.localized
            }

        }
     
        let imageUrlString = URL.init(string: delegateModel.profile_image)
        cell.imgViewManufacturer.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        
        cell.lblManufacturerName.text = delegateModel.name
        cell.lblDistance.text = delegateModel.duration
        cell.lblTimeAgo.text = "\(TITLE.LatestPurchase.localized) : \(String(describing: delegateModel.last_purchase))"
        cell.lblRating.text = delegateModel.rating
        cell.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: delegateModel.rating)
        
    cell.favouriteBtn.isSelected =  delegateModel.is_favourite == 1 ?  true : false
        
        cell.favouriteBtn.touchUp = { button in
            //favourite delegate
            
            self.viewModel.isSeller = 2
            self.viewModel.delegateId = delegateModel.delegate_id
            
            if cell.favouriteBtn.isSelected{
                
                self.viewModel.is_favourite = 0
                self.viewModel.addToFavourite {
                    cell.favouriteBtn.isSelected = false
                    self.saveTheLocalValue(delegateId: delegateModel.delegate_id, is_fav: 0)
                    self.tableView.reloadData()
                    
                }
            }else{
                self.viewModel.is_favourite = 1
                self.viewModel.addToFavourite {
                    cell.favouriteBtn.isSelected = true
                    self.saveTheLocalValue(delegateId: delegateModel.delegate_id, is_fav: 1)
                    self.tableView.reloadData()
                }
            }
        }
        return cell
    }

    func saveTheLocalValue(delegateId : Int, is_fav : Int)
    {
        for (index, model) in self.viewModel.delegateList.enumerated()
        {
            if model.delegate_id == delegateId
            {
                self.viewModel.delegateList[index].is_favourite = is_fav
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DelegateDetailVC.loadFromNib()
        let item = self.viewModel.delegateList[indexPath.section]
        vc.viewModel.requestDelegateModel = self.viewModel.requestDelegateModel
        vc.viewModel.requestDelegateModel.delegate_id = item.delegate_id
        vc.viewModel.request_Id = self.viewModel.requestDelegateModel.request_id
        vc.isFromSellerDetailRequest = self.isFromSellerDetailRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let tableHeight = tableView.bounds.size.height
        let contentHeight = tableView.contentSize.height
        let insetHeight = tableView.contentInset.bottom
        
        let yOffset = tableView.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        if (yOffsetAtBottom >= contentHeight) && (self.viewModel.current_page != self.viewModel.pageCount)
        {
            self.viewModel.current_page = self.viewModel.current_page + 1
            
            if self.viewModel.current_page <= self.viewModel.pageCount{
                getNearestDelegateList()
            }
        }
    }
}

