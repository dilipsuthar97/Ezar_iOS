//
//  MyRequestDetailVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 12/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView


class MyRequestDetailVC: BaseViewController,ButtonActionDelegate {
    
    var bottomView = ContainerView()
    var viewModel : MyRequestDetailViewModel = MyRequestDetailViewModel()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.getRequestDetailAPICall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.TrackLocation.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 55)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.requestDetails.localized
        setLeftButton()
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: MyRequestDetailTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: MyRequestDetailTableCell.cellIdentifier())
        
        tableView.register(UINib(nibName: ReqestInfoTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReqestInfoTableCell.cellIdentifier())
        
        let headerView = UINib.init(nibName: "SellerDetailHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "SellerDetailHeaderView")
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func onClickBottomButton(button: UIButton) {
        let vc = TrackLocationVC.loadFromNib()
        vc.originlat = Double(self.viewModel.latitude) ?? 0.0
        vc.originlong = Double(self.viewModel.longitude) ?? 0.0
        if let detail = self.viewModel.delegateDetail{
            let del_lat = (detail.delegate_lat.replacingOccurrences(of: "\t", with: ""))
            vc.destinationlat = Double(del_lat) ?? 0.0
            vc.destinationlong = Double(detail.delegate_lon ) ?? 0.0
            let countryCode = detail.country_code
            let mobileNumber = detail.mobile_number
            vc.mobileNumber = countryCode + mobileNumber
            vc.delegateId = detail.delegate_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MyRequestDetailVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else if section == 1{
            return self.viewModel.delegateDetail?.request_for.count ?? 0
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReqestInfoTableCell.cellIdentifier(), for: indexPath) as! ReqestInfoTableCell
        cell.selectionStyle = .none
        
        if indexPath.section == 0{
            let detailCell = tableView.dequeueReusableCell(withIdentifier: MyRequestDetailTableCell.cellIdentifier(), for: indexPath) as! MyRequestDetailTableCell
            detailCell.selectionStyle = .none
            
            if let detail = self.viewModel.delegateDetail{
                
                if detail.status == "approved"{
                    customBottonBar()
                }
                
                detailCell.nameLabel.text =  detail.name
                detailCell.ratingLabel.text = "\(detail.rating)/5"
                    detailCell.distanceLabel.text = detail.duration
                detailCell.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: (detail.rating))
                detailCell.statusLabel.text = "\(TITLE.customer_status.localized) \(detail.status)"
                
                if let imageUrl = detail.profile_image, !(imageUrl.isEmpty)
           {
                    let imageUrlString = URL.init(string: imageUrl)
                detailCell.profileImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
               }
            }
            return detailCell
            
        }else if indexPath.section == 1{
            if let item = self.viewModel.delegateDetail{
                cell.titleLbl.text = "• \(item.request_for[indexPath.row])"
            }
            return cell
            
        }else{
            if let data = self.viewModel.delegateDetail?.request_instruction{
                if indexPath.row == 0{
                    cell.titleLbl.text = "\(TITLE.DeliveryInstructions.localized): \(data.instructions)"
                }else if indexPath.row == 1{
                    cell.titleLbl.text = "\(TITLE.Name.localized): \(data.location_name)"
                }else{
                    cell.titleLbl.text = "\(TITLE.delegate_location_type.localized) \(data.location_type)"
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView?{
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SellerDetailHeaderView") as! SellerDetailHeaderView
     
        headerView.headerTitleLabel.textColor = Theme.blackColor
        headerView.headerTitleLabel.numberOfLines = 0
         headerView.headerTitleLabel.font = UIFont.init(customFont: CustomFont.FuturanHv, withSize: 11)
        
        if section == 0{
            return nil
        }else if section == 1{
            headerView.headerTitleLabel.text = " \(TITLE.delegate_request_for.localized)".uppercased()
        }
        else{
            headerView.headerTitleLabel.text = " \(TITLE.delegate_request_instruction.localized)".uppercased()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else if section == 1{
            if let requestFor =  self.viewModel.delegateDetail?.request_for, requestFor.count > 0{
                return 40
            }else{
                return 0
            }
        }else{
            return 40
        }
    }
}


//MARK:- Web Service Home APIs Calls
extension MyRequestDetailVC
{
    func getRequestDetailAPICall()
    {
        self.viewModel.getRequestDetail {
          
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}




