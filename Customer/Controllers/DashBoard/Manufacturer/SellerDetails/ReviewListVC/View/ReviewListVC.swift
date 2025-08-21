//
//  ReviewListVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 31/05/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewListVC: BaseTableViewController {
   
    let viewModel : ReviewListViewModel = ReviewListViewModel()
    var Id : Int = 0
    var reviewIdDictionary : [NSMutableDictionary] = [[:]]
    
    
    //MARK: View Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        reviewListWebservice()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.Reviews.localized
        setLeftButton()
    }
    
    func setupTableView() {
        
       tableView.register(UINib(nibName: SellerReviewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerReviewCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
}

extension ReviewListVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: SellerReviewCell.cellIdentifier(), for: indexPath) as! SellerReviewCell
        let item = viewModel.reviewList[indexPath.row]
        
        cell.likeLabel.text = String(format: "%d", keyValue(review_id: item.review_id ?? -1, checkValue: 1, removeValue: -1) ? item.like + 1 : item.like)
        cell.unlikeLabel.text = String(format: "%d", keyValue(review_id: item.review_id ?? -1, checkValue: 0, removeValue: -1) ? item.dislike + 1 : item.dislike)
        
        //cell.titleLabel.text = item.title
        cell.nameLabel.text = item.name
        cell.dateLabel.text = item.date
        //cell.detailLabel.text = item.reivew
        
        if item.certified_buyer{
            cell.certifiedImgView.image = UIImage(named : "tick_yellow")
            cell.cerifiedBLabel.isHidden = false
        }else{
            
            cell.certifiedImgView.image = UIImage(named : "")
            cell.cerifiedBLabel.isHidden = true
        }
        
        if item.display_review == 1{
            cell.titleLabel.text = item.title
            cell.detailLabel.text = item.reivew
            cell.titleLabel.isHidden = false
            cell.detailLabel.isHidden = false
        }else{
            cell.titleLabel.isHidden = true
            cell.detailLabel.isHidden = true
        }
        
        if item.display_rating == 1{
            
            cell.ratingView.isHidden = false
            
            if !item.rating.isEmpty{
                
                cell.ratingLbl.text =  item.rating
            }
            
        }else{
            cell.ratingView.isHidden = true
        }
        
        cell.likeBtn.touchUp = { button in
            if !(LocalDataManager.getGuestUser()){
            self.viewModel.review_id = item.review_id
            self.viewModel.upVote = 1
            if !(self.keyValue(review_id: item.review_id ?? -1, checkValue: 1, removeValue: 0))
            {
                self.viewModel.setReviewLikeDislike {
                    let dic : NSMutableDictionary = [item.review_id ?? 0 : self.viewModel.upVote ?? -1]
                    self.reviewIdDictionary.append(dic)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            }else{
              self.showLoginPopup()
            }
        }
        
        cell.dislikeBtn.touchUp = { button in
            if !(LocalDataManager.getGuestUser()){
            self.viewModel.review_id = item.review_id
            self.viewModel.upVote = 0
            if !(self.keyValue(review_id: item.review_id ?? -1, checkValue: 0, removeValue: 1))
            {
                self.viewModel.setReviewLikeDislike {
                    let dic : NSMutableDictionary = [item.review_id ?? 0 : self.viewModel.upVote ?? -1]
                    self.reviewIdDictionary.append(dic)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            }else{
               self.showLoginPopup()
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func keyValue(review_id : Any, checkValue : Int, removeValue : Int) -> Bool
    {
        let id : Int = review_id as! Int
        let check = self.reviewIdDictionary.contains([id : checkValue])
        for (index, dic) in self.reviewIdDictionary.enumerated()
        {
            if let value : Int = dic[id] as? Int, value == removeValue
            {
                if index < self.reviewIdDictionary.count{
                    self.reviewIdDictionary.remove(at: index)
                }
            }
        }
        return check
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
                 reviewListNextWebservice()
               
            }
            
        }
    }
    
    func showLoginPopup(){
        let alert = UIAlertController(title: TITLE.customer_login_required.localized, message: TITLE.customer_guest_alert.localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler:{ action in
            let vc = LoginViewController.loadFromNib()
            vc.isFromUserGuest = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
}


extension ReviewListVC {
    
    func reviewListWebservice(){
       viewModel.id = Id
        self.viewModel.getAllReviews {
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    
    func reviewListNextWebservice(){
        viewModel.id = Id
        self.viewModel.getAllReviewsNext {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}



