//
//  NotificationsViewController.swift
//  Customer
//
//  Created by webwerks on 22/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class FAQsVC: BaseTableViewController {

    //MARK:- Variable declaration

    var viewModel = FAQsViewModel()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        self.callAPIForFAQs()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helpers for data & UI
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.FAQs.localized
        topConstraint.constant = 10
    }
    
    func setupTableView() {
       tableView.register(UINib(nibName: FAQTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: FAQTableViewCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }

}
//MARK:- TableView datasoruce & delegate methods

extension FAQsVC : UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.faqDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.cellIdentifier(), for: indexPath) as! FAQTableViewCell
        cell.selectionStyle = .none
        let item = viewModel.faqDetails[indexPath.row]
        
        cell.titleLabel.text = item.question
        
        if let detail = item.answer, detail != ""{
            cell.detailLabel.text = detail.getStringFromHtml()
        }else{
            cell.detailLabel.text = TITLE.noDescription.localized
        }
        
        cell.detailHeightConstraints.priority = .defaultHigh
        cell.dropdownImg.image = UIImage(named : "downarrow")
        
        if item.isRowExpanded == indexPath.row{
            cell.detailHeightConstraints.priority = .defaultLow
            cell.dropdownImg.image = UIImage(named :"uparrow")
            
        }
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = viewModel.faqDetails[indexPath.row]
          if data.isRowExpanded == indexPath.row{
           return UITableView.automaticDimension
          }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        for(index, _) in (viewModel.faqDetails.enumerated()){
             viewModel.faqDetails[index].isRowExpanded = -1
        }
        viewModel.faqDetails[indexPath.row].isRowExpanded = indexPath.row
        tableView.reloadData()
    }
}

extension FAQsVC {
    
    func callAPIForFAQs()
    {
        self.viewModel.getFaqDetails {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


