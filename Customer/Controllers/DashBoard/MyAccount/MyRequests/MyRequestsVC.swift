//
//  MyRequestsVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 26/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MyRequestsVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel : MyRequestsViewModel = MyRequestsViewModel()

    @IBOutlet weak var delegateLbl: UILabel!
    //MARK:- View Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.myRequestAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.requests.localized
        delegateLbl.text = TITLE.customer_project_delegate.localized
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: MyRequestsTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: MyRequestsTableCell.cellIdentifier())
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()

    }
}

//MARK:- TableView datasource & delegate methods

extension MyRequestsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRequestsTableCell.cellIdentifier(), for: indexPath) as! MyRequestsTableCell
        cell.selectionStyle = .none
        
        let item = self.viewModel.requestList[indexPath.row]
        
        cell.cancelButton.isHidden = delegateStatus(status: item.status.uppercased())
        cell.status.text = item.status
        cell.addressLabel.text = item.delegate_address
        cell.nameLabel.text = item.delegate_name
        if let id = item.request_id{
        cell.idLabel.text = "\(TITLE.customer_request_id.localized) \(id)"
        }
        
        if let imageUrl = item.delegate_profile_image, !(imageUrl.isEmpty)
        {
            let imageUrlString = URL.init(string: imageUrl)
            cell.profileImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        }else{
          cell.profileImgView.image = UIImage.init(named: "placeholder")
        }
        cell.cancelButton.touchUp = { button in
            
            let alert = UIAlertController(title: TITLE.cancel_Request.localized, message: TITLE.cancel_request_message.localized, preferredStyle: .alert)
            
            let yesActtion = UIAlertAction(title: TITLE.yes.localized, style: .default) { (alert) in
                self.changeTheStatus(request_id: item.request_id ?? 0, status: "cancelled")
            }
            let cancelAction = UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
            alert.addAction(yesActtion)
            alert.addAction(cancelAction)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
        return cell
    }
    
    func delegateStatus(status: String) -> Bool
    {
        var isStatus : Bool = true
        switch status
        {
        case RequestStatus.Approved.rawValue.uppercased():
            isStatus = false
            break
        case RequestStatus.Rejected.rawValue.uppercased():
            break
        case RequestStatus.Arrived.rawValue.uppercased():
            isStatus = false
            break
        case RequestStatus.Cancelled.rawValue.uppercased():
            break
        default:
            break
        }
        return isStatus
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyRequestDetailVC.loadFromNib()
        let item = self.viewModel.requestList[indexPath.row]
        
        if let id = item.request_id{
            vc.viewModel.request_id = id
        }
        
        if let id = item.delegate_id{
            vc.viewModel.delegate_id = id
        }
        vc.viewModel.delegate_status = item.status
        vc.viewModel.latitude = item.latitude
        vc.viewModel.longitude = item.longitude
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func changeTheStatus(request_id : Int, status : String)
    {
        self.viewModel.request_id = request_id
        self.viewModel.status = status
        self.viewModel.changeStatus {
            self.myRequestAPICall()
        }
    }
}

//MARK:- Web Service Home APIs Calls
extension MyRequestsVC
{
    func myRequestAPICall()
    {
        let profile = Profile.loadProfile()
        self.viewModel.customer_id = profile?.id ?? 0
        
        self.viewModel.getMyRequest {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

