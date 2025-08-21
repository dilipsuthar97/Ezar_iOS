//
//  SideMenuVC.swift
//  Thoab App
//
//  Created by webwerks on 4/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SideMenuVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuArray = [
        
        ImgObjData(title: "customer_home",
                   image: UIImage(named: "sideHome"),
                   key: SideMenuIndex.home.key),
        
        ImgObjData(title: "customer_my_account",
                   image: UIImage(named: "usericon"),
                   key: SideMenuIndex.my_account.key),
        
        ImgObjData(title: "customer_measurements",
                   image: UIImage(named: "sidemeasurement"),
                   key: SideMenuIndex.measurements.key),
        
        ImgObjData(title: "customer_scanIntro",
                   image: UIImage(named: "faqs"),
                   key: SideMenuIndex.scanIntro.key),
        
        ImgObjData(title: "customer_settings",
                   image: UIImage(named: "sidesettings"),
                   key: SideMenuIndex.settings.key),
        
        ImgObjData(title: "customer_termsAndCondition",
                   image: UIImage(named: "tnc"),
                   key: SideMenuIndex.termsAndCondition.key),
        
        ImgObjData(title: "customer_privacy_policy",
                   image: UIImage(named: "privacy_policy"),
                   key: SideMenuIndex.privacy_policy.key),
        
//        ImgObjData(title: "customer_offer",
//                   image: UIImage(named: "SideOffer"),
//                   key: SideMenuIndex.offer.key),
        
        ImgObjData(title: "intive_friends",
                   image: UIImage(named: "intive_friends"),
                   key: SideMenuIndex.invite_friends.key),

        ImgObjData(title: "customer_help",
                   image: UIImage(named: "sideHelp"),
                   key: SideMenuIndex.help.key),
        
        ImgObjData(title: "customer_whatsApp_us",
                   image: UIImage(named: "whatsapp"),
                   key: SideMenuIndex.whatsApp_us.key),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableUI()
    }
    
    func configureTableUI() {
        let headerView = UINib.init(nibName: "MenuHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "MenuHeaderView")
        tableView.register(UINib(nibName: MenuCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: MenuCell.cellIdentifier())
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: - UITableViewDataSource
extension SideMenuVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.cellIdentifier(), for: indexPath) as! MenuCell
        let data = self.menuArray[indexPath.row]
        cell.controllerTitleLabel.text = data.title.localized
        cell.iconImage.image = data.image
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView : MenuHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeaderView") as? MenuHeaderView else {
            return UIView()
        }
        
        let profile = Profile.loadProfile()
        headerView.nameLabel.text = LocalDataManager.getGuestUser() == true ? TITLE.Hello.localized : profile?.name
       headerView.emailLabel.text = LocalDataManager.getGuestUser() == true ? TITLE.SIGNIN.localized : profile?.email
        
        if let imageUrl = profile?.profileImg, !(imageUrl.isEmpty) {
            let imageUrlString = URL(string: imageUrl)
            headerView.profileImage.sd_setImage(
                with: imageUrlString,
                placeholderImage: UIImage(named: "placeholder_user"),
                options: .continueInBackground,
                progress: nil,
                completed: nil)
        }
        
        headerView.profileImage.touchUp = { img in
            self.panel?.closePanel()
            var dic = [:]
            if (LocalDataManager.getGuestUser()) {
                dic = ["index": SideMenuIndex.login.key]
            } else {
                dic = ["index": SideMenuIndex.profile.key]
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideViewContoller"),
                                            object: nil,
                                            userInfo: dic)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 185.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.menuArray[indexPath.row]
        self.panel?.closePanel()
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "SideViewContoller"),
                                        object: nil,
                                        userInfo: ["index": data.key])
    }
}
