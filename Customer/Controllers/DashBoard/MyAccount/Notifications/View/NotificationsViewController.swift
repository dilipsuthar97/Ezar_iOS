//
//  NotificationsViewController.swift
//  Customer
//
//  Created by webwerks on 22/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    //MARK:- Variable declaration
    @IBOutlet weak var backButton: ActionButton!
    @IBOutlet weak var tableView: UITableView!
//    var notifications = ["Brand new mens collection", "Brand new mens collection","Brand new mens collection","Brand new mens collection"]
    var viewModel = NotificationsViewModel()

    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
         self.setupUI()
        self.callAPIForNotifications()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() {
        navigationItem.title = "customer_notifications".localized
        setNavigationBarHidden(hide: false)
        setLeftButton()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: NotificationsCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: NotificationsCell.cellIdentifier())
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}


//MARK:- TableView datasoruce & delegate methods

extension NotificationsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsCell.cellIdentifier(), for: indexPath) as! NotificationsCell
        cell.selectionStyle = .none
        let model = viewModel.notificationList[indexPath.row]
        cell.titleLabel.text = model.title
        cell.descriptionLabel.text = model.description
        cell.timeLabel.text = COMMON_SETTING.timeInterval(timeAgo: model.created_at)
//        let imageUrlString = URL.init(string: model.image)
//        cell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        return cell
    }
}

extension NotificationsViewController {
    
    func callAPIForNotifications()
    {
        self.viewModel.getNotificationList {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
