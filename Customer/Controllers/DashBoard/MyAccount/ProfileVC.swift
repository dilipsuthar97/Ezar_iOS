//
//  ProfileVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: BaseViewController {
    
    //MARK: Variable
    
    @IBOutlet weak var backButton: ActionButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ProfileViewModel()
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupTableView()
        callWebServiceForMyAccount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func callWebServiceForMyAccount() {
        let profile = Profile.loadProfile()
        self.viewModel.customer_id = profile?.id ?? 0
        self.viewModel.getMyAccountDetails {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.top)
            }
        }
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.myAccount.localized
    }
    
    func setupTableView(){
        tableView.register(UINib(nibName: "CustomTableCell", bundle: nil), forCellReuseIdentifier: CustomTableCell.cellIdentifier())
        tableView.register(UINib(nibName: "ProfileTableCell", bundle: nil), forCellReuseIdentifier: "ProfileTableCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func onClickBack(_ sender: ActionButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return viewModel.requestList.count
        } else {
            return viewModel.settingList.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as! ProfileTableCell
            let profile = Profile.loadProfile()
            headerCell.nameLabel.text = profile?.name
            headerCell.emailLabel.text = profile?.email
            headerCell.mobileNoLabel.text = profile?.mobileNo
            if let imageUrl = profile?.profileImg {
                let imageUrlString = URL(string: imageUrl)
                headerCell.profileImgView.sd_setImage(with: imageUrlString,
                                                      placeholderImage: UIImage(named: "placeholder_user"),
                                                      options: .continueInBackground,
                                                      progress: nil,
                                                      completed: nil)
            }
            
            headerCell.editButton.setTitle(TITLE.editProfile.localized, for: .normal)
            headerCell.selectionStyle = .none
            headerCell.editButton.touchUp = { button in
                let vc = EditProfileVC.loadFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return headerCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.cellIdentifier(), for: indexPath) as! CustomTableCell
        cell.selectionStyle = .none
        cell.countLabel.isHidden = true
        cell.nameLabel.font = UIFont.init(customFont: CustomFont.FuturanM, withSize: 17)

        if indexPath.section == 1 {
            let item = viewModel.requestList[indexPath.row]
            cell.nameLabel.text = item["name"]?.localized
            cell.imgView.image = UIImage(named : item["image"]!)?.imageFlippedForRightToLeftLayoutDirection()

            if indexPath.row == 0 {
                cell.countLabel.isHidden = false
                let profile = Profile.loadProfile()
                if let count  = profile?.notification_count{
                    cell.countLabel.text = "(" + String(count) + ")"
                }
            }
        } else {
            let item = viewModel.settingList[indexPath.row]
            cell.nameLabel.text = item["name"]?.localized
            cell.imgView.image = UIImage(named : item["image"]!)?.imageFlippedForRightToLeftLayoutDirection()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        if (section == 0) || (section == 1) {
            let footerView = UIView()
            let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - 30, height: 0.5))
            separatorView.backgroundColor = Theme.darkGray
            footerView.addSubview(separatorView)
            return footerView
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }else{
            return 40
        }
    }
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        }
        else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                let vc = NotificationsViewController.loadFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = MyRequestsVC.loadFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let orderVC = OrderTab.loadFromNib()
                self.navigationController?.pushViewController(orderVC, animated: true)
            case 3:
                let vc  = MyReturnListVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = MeasurementVC.loadFromNib()
                vc.isProfileMeasurement = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = ScanBodyMeasurementVC.loadFromNib()
                vc.isFromIntro = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 6:
                let vc = FavoriteTab.loadFromNib()
                self.navigationController?.pushViewController(vc, animated: true)
            case 7:
                let vc = RewardHistoryVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                let vc = SettingsViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = ReviewFeedbackRootVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = FAQsVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                Profile.removeProfile()
                Profile.removeInviteLink()
                LocalDataManager.setDeviceTokenRegister(false)
                LocalDataManager.setGuestUser(_isGuestUser: true)
                EzarApp.setRootViewController(type: LoginViewController.self)
            default:
                break
            }
        }
    }
}
