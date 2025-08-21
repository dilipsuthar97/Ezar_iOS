//
//  MyReturnListVC.swift
//  Customer
//
//  Created by webwerks on 10/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MyReturnListVC: BaseTableViewController {

    var viewModel : MyReturnListViewModel = MyReturnListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyReturnList()
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
        
        tableView.register(UINib(nibName: ReturnItemCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReturnItemCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func getMyReturnList()
    {
        self.viewModel.myReturnList {
            self.tableView.reloadData()
        }
    }
}

extension MyReturnListVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.returnItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReturnItemCell.cellIdentifier(), for: indexPath) as! ReturnItemCell
        let returnItem = self.viewModel.returnItemList[indexPath.row]
        cell.lblOrderId.text = returnItem.order_incremental_id
        cell.lblReturnId.text = String(format: "%d", returnItem.request_id)
        cell.lblCreatedAt.text = returnItem.updated_at
        cell.statusLabel.text = returnItem.status
        cell.commentLabel.text = String(format: "%d %@", returnItem.comment_count, TITLE.Comment.localized)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let returnItem = self.viewModel.returnItemList[indexPath.row]
        let vc : MyReturnsVC  = MyReturnsVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
        vc.viewModel.returnItem = returnItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
