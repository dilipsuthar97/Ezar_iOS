//
//  HelpViewController.swift
//  Customer
//
//  Created by Priyanka Jagtap on 13/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class HelpViewController: BaseTableViewController {
    
    //MARK:- Variable declaration
    
    var viewModel = HelpViewModel()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        self.callAPIForHelps()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helpers for data & UI
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.help.localized
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

extension HelpViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.helpDetails.count
    } 
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.cellIdentifier(), for: indexPath) as! FAQTableViewCell
        cell.selectionStyle = .none
        let item = viewModel.helpDetails[indexPath.row]
        
        cell.titleLabel.text = item.topic
        
        if let detail = item.description, detail != ""{
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
        
        let data = viewModel.helpDetails[indexPath.row]
        if data.isRowExpanded == indexPath.row{
            return UITableView.automaticDimension
        }else{
            return 70
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for(index, _) in (viewModel.helpDetails.enumerated()){
            viewModel.helpDetails[index].isRowExpanded = -1
        }
        
        viewModel.helpDetails[indexPath.row].isRowExpanded = indexPath.row
        
        tableView.reloadData()
    }
}

extension HelpViewController {
    
    func callAPIForHelps()
    {
        self.viewModel.getHelpDetails {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

