//
//  StyleInfoVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/30/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class StyleInfoVC: BaseTableViewController {

    var styleInfo : [Style_selection]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView() 
        // Do any additional setup after loading the view.
    }


    //MARK:- Helpers for data & UI
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.customer_style_info.localized
        setLeftButton()
        topConstraint.constant = 10
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: StyleInfoTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: StyleInfoTableViewCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
}

//MARK:- TableView datasoruce & delegate methods
extension StyleInfoVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.styleInfo{
            return list.count
        }else{
             INotifications.show(message: TITLE.customer_noData_available.localized)
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: StyleInfoTableViewCell.cellIdentifier(), for: indexPath) as! StyleInfoTableViewCell
        
        if let item = self.styleInfo?[indexPath.row]{
            if let title =  item.title{
                cell.nameTxtLbl.text = title
            }
            
            if let image = item.image{
                
                let imageUrlString = image
                let encodedLink = imageUrlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let encodedURL = NSURL(string: encodedLink!)! as URL
                
                cell.styleImageView.sd_setImage(with: encodedURL, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
            }
        }
  
        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return U
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

