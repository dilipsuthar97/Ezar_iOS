//
//  DelegateDetailVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 12/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView


class DelegateDetailVC: BaseViewController {
    
    var bottomView = ContainerView()
    var viewModel : DelegateDetailViewModel = DelegateDetailViewModel()
    var sellerViewModel : SellerViewModel = SellerViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    var reviewIdDictionary : [NSMutableDictionary] = [[:]]
    var footerView : UIView!
    @IBOutlet weak var tblHeightConstraints: NSLayoutConstraint!
    var timer : Timer? = nil
    let refreshControl = UIRefreshControl()
    var isFromSellerDetailRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupUI()
        detailLabel.text = TITLE.customer_delegate_message.localized
        customBottonBar()
        if self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("PENDING")
        {
            //detailLabel.textAlignment = .center
            detailLabel.text = TITLE.delegate_pending_request.localized
        }
        self.getDelegateDetailAPICall()
        if self.timer == nil
        {
            self.timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { (timer) in
                self.getDelegateDetailAPICall()
            })
        }
    }
    
    //MARK:- Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        var bottomTitle : String =  TITLE.RequestDelegate.localized.uppercased()
        if self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("APPROVED")
        {
            bottomTitle = TITLE.TrackLocation.localized.uppercased()
        }
        else if self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("PENDING")
        {
            bottomTitle = TITLE.cancel_Request.localized
        }
        
        buttonArray = [bottomTitle]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 10, y: (APP_DELEGATE.window?.frame.size.height)!-70, width: (APP_DELEGATE.window?.frame.size.width)!,height: 55)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
        
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.timer != nil
        {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.timer != nil
        {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.delegateDetail.localized
        ratingView.isUserInteractionEnabled = false
    }
    
    @objc func pullToRefresh(refreshControl: UIRefreshControl) {
        self.getDelegateDetailAPICall()
        refreshControl.endRefreshing()
    }
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        tableView.register(UINib(nibName: SellerReviewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerReviewCell.cellIdentifier())
        
        let headerView = UINib.init(nibName: "SellerDetailHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "SellerDetailHeaderView")
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func onClickLeftButton(button: UIButton) {
        if COMMON_SETTING.isFromSellerRequest == true{
            if self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("APPROVED") || self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("PENDING") {
                self.setTabBarIndex(index: 2)
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            if self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("APPROVED") || self.viewModel.requestDelegateModel.delegate_status.uppercased().contains("PENDING")
            {
                let vc = COMMON_SETTING.popToAnyController(type: ShoppingBagVC.self, fromController: self)
                self.navigationController?.popToViewController(vc, animated: true)
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension DelegateDetailVC : ButtonActionDelegate
{
    func onClickBottomButton(button: UIButton) {
        
        if COMMON_SETTING.isFromSellerRequest == true{
            if button.titleLabel?.text == TITLE.CHECKSTATUS.localized.uppercased()
            {
                INotifications.show(message: TITLE.delegate_status.localized)
            }
            else if button.titleLabel?.text == TITLE.TrackLocation.localized.uppercased()
            {
                let vc = TrackLocationVC.loadFromNib()
                
                vc.originlat = Double(self.viewModel.requestDelegateModel.latitude) ?? 0.0
                vc.originlong = Double(self.viewModel.requestDelegateModel.longitude) ?? 0.0
                let del_lat = (self.viewModel.delegateDetail?.delegate_lat.replacingOccurrences(of: "\t", with: "")) ?? "0.0"
                vc.destinationlat = Double(del_lat) ?? 0.0
                vc.destinationlong = Double(self.viewModel.delegateDetail?.delegate_lon ?? "0.0") ?? 0.0
                
                let countryCode = self.viewModel.delegateDetail?.country_code ?? ""
                let mobileNumber = self.viewModel.delegateDetail?.mobile_number ?? ""
                
                vc.mobileNumber = countryCode + mobileNumber
                //self.viewModel.countryCode + self.viewModel.mobileNumber
                
                vc.delegateId = self.viewModel.delegateDetail?.delegate_id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if button.titleLabel?.text == TITLE.RequestDelegate.localized.uppercased()
            {
                self.viewModel.sendDelegateRequest {
                    if self.viewModel.responseCode == 200
                    {
                        self.viewModel.requestDelegateModel.delegate_status = "pending"
                        self.customBottonBar()
                        button.titleLabel?.text = TITLE.cancel_Request.localized
                        self.setTabBarIndex(index: 2)
                    }else{
                        if let viewControllers = self.navigationController?.viewControllers{
                            for aViewController in viewControllers
                            {
                                if aViewController is HomeRequestsVC
                                {
                                    let aVC = aViewController as! HomeRequestsVC
                                    
                                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                self.viewModel.status = "cancelled"
                self.viewModel.changeStatus {
                    if self.viewModel.responseCode == 200
                    {
                        self.viewModel.request_Id = 0
                        self.viewModel.requestDelegateModel.delegate_status = ""
                        self.customBottonBar()
                    }
                }
            }
        }else{
            if button.titleLabel?.text == TITLE.CHECKSTATUS.localized.uppercased()
            {
                INotifications.show(message: TITLE.delegate_status.localized)
            }
            else if button.titleLabel?.text == TITLE.TrackLocation.localized.uppercased()
            {
                let vc = TrackLocationVC.loadFromNib()
                vc.originlat = Double(self.viewModel.requestDelegateModel.latitude) ?? 0.0
                vc.originlong = Double(self.viewModel.requestDelegateModel.longitude) ?? 0.0
                let del_lat = (self.viewModel.delegateDetail?.delegate_lat.replacingOccurrences(of: "\t", with: "")) ?? "0.0"
                vc.destinationlat = Double(del_lat) ?? 0.0
                vc.destinationlong = Double(self.viewModel.delegateDetail?.delegate_lon ?? "0.0") ?? 0.0
                
                let countryCode = self.viewModel.delegateDetail?.country_code ?? ""
                let mobileNumber = self.viewModel.delegateDetail?.mobile_number ?? ""
                
                vc.mobileNumber = countryCode + mobileNumber
                //self.viewModel.countryCode + self.viewModel.mobileNumber
                
                vc.delegateId = self.viewModel.delegateDetail?.delegate_id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if button.titleLabel?.text == TITLE.RequestDelegate.localized.uppercased()
            {
                self.viewModel.sendDelegateRequest {
                    if self.viewModel.responseCode == 200 {
                        self.viewModel.requestDelegateModel.delegate_status = "pending"
                        self.customBottonBar()
                        button.titleLabel?.text = TITLE.cancel_Request.localized
                        INotifications.show(message: "your_request_has_been_sent".localized,
                                            type: .success)
                        self.navigationController?.backToViewController(viewController: ShoppingBagVC.self)
                    } else {
                        if let viewControllers = self.navigationController?.viewControllers{
                            for aViewController in viewControllers{
                                if aViewController is HomeRequestsVC {
                                    let aVC = aViewController as! HomeRequestsVC
                                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                                }
                            }
                        }
                    }
                }
            }
            else {
                self.viewModel.status = "cancelled"
                self.viewModel.changeStatus {
                    if self.viewModel.responseCode == 200 {
                        self.viewModel.request_Id = 0
                        self.viewModel.requestDelegateModel.delegate_status = ""
                        self.customBottonBar()
                    }
                }
            }
        }
    }
}

//MARK:- UITableViewDelegate & DataSource Methods
extension DelegateDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SellerReviewCell.cellIdentifier(), for: indexPath) as! SellerReviewCell
        let item = viewModel.reviewList[indexPath.row]
        
        cell.likeLabel.text = String(format: "%d", keyValue(review_id: item.review_id ?? -1, checkValue: 1, removeValue: -1) ? item.like + 1 : item.like)
        
        cell.unlikeLabel.text = String(format: "%d", keyValue(review_id: item.review_id ?? -1, checkValue: 0, removeValue: -1) ? item.dislike + 1 : item.dislike)
        
        cell.titleLabel.text = item.title
        cell.nameLabel.text = item.name
        cell.dateLabel.text = item.date
        cell.detailLabel.text = item.reivew
        
        if item.certified_buyer{
            cell.certifiedImgView.image = UIImage(named : "tick_yellow")
            cell.cerifiedBLabel.isHidden = false
        } else {
            cell.certifiedImgView.image = UIImage(named : "")
            cell.cerifiedBLabel.isHidden = true
        }
        
        cell.likeBtn.touchUp = { button in
            if !(LocalDataManager.getGuestUser()) {
                self.sellerViewModel.review_id = item.review_id
                self.sellerViewModel.upVote = 1
                self.sellerViewModel.reivewType = "d"
                if !(self.keyValue(review_id: item.review_id ?? -1, checkValue: 1, removeValue: 0))
                {
                    self.sellerViewModel.setReviewLikeDislike {
                        let dic : NSMutableDictionary = [item.review_id ?? 0 : self.sellerViewModel.upVote ?? -1]
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
                
                self.sellerViewModel.review_id = item.review_id
                self.sellerViewModel.upVote = 0
                self.sellerViewModel.reivewType = "d"
                if !(self.keyValue(review_id: item.review_id ?? -1, checkValue: 0, removeValue: 1))
                {
                    self.sellerViewModel.setReviewLikeDislike {
                        let dic : NSMutableDictionary = [item.review_id ?? 0 : self.sellerViewModel.upVote ?? -1]
                        self.reviewIdDictionary.append(dic)
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }else{
                self.showLoginPopup()
            }
        }
        
        cell.selectionStyle = .none
        self.viewForFooterInTableView()
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
                self.reviewIdDictionary.remove(at: index)
            }
        }
        return check
    }
    
    func viewForFooterInTableView()
    {
        if self.footerView == nil
        {
            self.footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-10, height: 40))
            self.tableView.tableFooterView = footerView
            
            let showMoreLabel = UILabel(frame: CGRect(x: self.footerView.frame.size.width - 170, y: 0, width: 160, height: 40))
            showMoreLabel.textColor = Theme.lightGray
            showMoreLabel.text = TITLE.customer_see_all_reviews.localized
            showMoreLabel.textAlignment = .right
            showMoreLabel.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 13)
            showMoreLabel.addAttributeText(text: TITLE.customer_see_all_reviews.localized,textColor : Theme.lightGray)
            showMoreLabel.isUserInteractionEnabled = true
            
            
            let lButton = ActionButton(type: .custom)
            lButton.setupAction()
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect(x: self.footerView.frame.size.width - 170, y: 0, width: 160, height: 40)
            
            
            lButton.touchUp = { button in
                let vc : ReviewListVC  = ReviewListVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                vc.viewModel.reivewType = "d"
                vc.Id = self.viewModel.delegateDetail?.delegate_id ?? 0
                vc.viewModel.total_reviews = self.viewModel.delegateDetail?.reviewRating?.reviews?.total ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.footerView.addSubview(showMoreLabel)
            self.footerView.addSubview(lButton)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.reviewList.count > 0{
            let optionsHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SellerDetailHeaderView") as! SellerDetailHeaderView
            optionsHeaderView.headerTitleLabel.text = TITLE.comments_by_others.localized
            optionsHeaderView.headerTitleLabel.textColor = Theme.lightGray
            return optionsHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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


//MARK:- Web Service Home APIs Calls
extension DelegateDetailVC
{
    func getDelegateDetailAPICall()
    {
        self.viewModel.getDelegateDetail {
            DispatchQueue.main.async {
                
                self.viewModel.requestDelegateModel.delegate_status = self.viewModel.delegateDetail?.status ?? ""
                self.customBottonBar()
                if self.viewModel.reviewList.count > 0{
                    self.tableView.reloadData()
                    self.tblHeightConstraints.constant = 800
                }else{
                    self.tblHeightConstraints.constant = 0
                }
                
                if let detail = self.viewModel.delegateDetail{
                    self.nameLabel.text =  detail.name
                    self.ratingLabel.text = "\(detail.rating)/5"
                    
                    self.distanceLabel.text = detail.duration
                    self.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: (String(detail.rating)))
                    if let imageUrl = detail.profile_image, !(imageUrl.isEmpty)
                    {
                        let imageUrlString = URL.init(string: imageUrl)
                        self.profileImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                    }
                }
            }
        }
    }
}




