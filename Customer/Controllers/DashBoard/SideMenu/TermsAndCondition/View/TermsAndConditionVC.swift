//
//  TermsAndConditionVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/2/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class TermsAndConditionVC: BaseTableViewController {

    //MARK:- Variable declaration
    var viewModel = TermsAndConditionViewModel()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
       callAPIForTermsAndCondition()
    }
    
    //MARK:- Helpers for data & UI
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.customer_termsAndCondition.localized
        topConstraint.constant = 10
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: CmsPagesTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: CmsPagesTableViewCell.cellIdentifier())

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
}

//MARK:- TableView datasoruce & delegate methods
extension TermsAndConditionVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.termsAndCondition.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CmsPagesTableViewCell.cellIdentifier(), for: indexPath) as! CmsPagesTableViewCell
        cell.selectionStyle = .none
        let item  = self.viewModel.termsAndCondition[indexPath.row]

        cell.descLbl.set(html: item.content ?? "")
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- Api call
extension TermsAndConditionVC {
    
    func callAPIForTermsAndCondition()
    {
    
        self.viewModel.getTermsAndCondition{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

