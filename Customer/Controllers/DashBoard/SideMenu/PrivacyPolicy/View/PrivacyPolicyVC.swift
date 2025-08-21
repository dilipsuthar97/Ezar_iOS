//
//  PrivacyPolicyVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/3/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: BaseTableViewController {

    //MARK:- Variable declaration
    var viewModel = PrivacyPolicyViewModel()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
         setupTableView()
        callAPIForPrivacyPolicy()
    }
    
    //MARK:- Helpers for data & UI
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.customer_privacy_policy.localized
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
extension PrivacyPolicyVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.privacyPolicy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CmsPagesTableViewCell.cellIdentifier(), for: indexPath) as! CmsPagesTableViewCell
        cell.selectionStyle = .none
        let item  = self.viewModel.privacyPolicy[indexPath.row]
        
        //cell.descLbl.set(html: item.content ?? "")
        cell.descLbl.attributedText = NSAttributedString(html: item.content ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- Api call
extension PrivacyPolicyVC {
    
    func callAPIForPrivacyPolicy()
    {
        
        self.viewModel.getPrivacyPolicy{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension NSAttributedString {
     convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.unicode, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}
