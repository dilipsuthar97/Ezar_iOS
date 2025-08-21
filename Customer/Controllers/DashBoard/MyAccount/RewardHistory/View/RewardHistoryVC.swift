//
//  RewardHistoryVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 3/12/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class RewardHistoryVC: BaseTableViewController {
    
    //MARK:- Variable declaration
    var viewModel = RewardHistoryViewModel()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        callAPIForewardHistory()
    }
    
    func setupUI() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.customer_rewardsHistory.localized
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: RewardHistoryTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: RewardHistoryTableViewCell.cellIdentifier())
        tableView.register(UINib(nibName: RemainingRewardPointsTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: RemainingRewardPointsTableViewCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
}

//MARK:- UITableViewDataSource,UITableViewDelegate
extension RewardHistoryVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rewardHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RewardHistoryTableViewCell.cellIdentifier(), for: indexPath) as! RewardHistoryTableViewCell
        cell.selectionStyle = .none
        
        let item = self.viewModel.rewardHistoryList[indexPath.row]
        
        if let point = item.point{
             cell.pointsLbl.text = String(point)
        }
       
        if !item.transaction_type.isEmpty{
            cell.transactiontypeLbl.text = item.transaction_type
        }
        
        if !item.description.isEmpty{
            cell.descriptionLbl.text = item.description
        }
        
        if let balance = item.balance{
            cell.balanceLbl.text = String(balance)
        }
        
        if !item.created_at.isEmpty{
            cell.createdAtLbl.text = item.created_at
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemainingRewardPointsTableViewCell.cellIdentifier()) as! RemainingRewardPointsTableViewCell
        
        if !self.viewModel.available_balance.isEmpty{
             cell.rewardsPointsValLbl.text = self.viewModel.available_balance
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.viewModel.rewardHistoryList.count > 0{
            return 60
        }else{
            return 0
        }
    }
}

//MARK:- Api call
extension RewardHistoryVC {
    
    func callAPIForewardHistory()
    {
        
        self.viewModel.getRewardHistory{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
