//
//  MeasurementDetailsTrackVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/30/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class MeasurementDetailsTrackVC: BaseTableViewController {
    
  //MARK:-Veriable declaration
    var optionList : Measurements_info?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Helpers for data & UI
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.MeasurementDetail.localized
        setLeftButton()
        topConstraint.constant = 10
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: DetailTractTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: DetailTractTableViewCell.cellIdentifier())
        tableView.register(UINib(nibName: DetailTrackHeaderTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: DetailTrackHeaderTableViewCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
}

//MARK:- TableView datasoruce & delegate methods
extension MeasurementDetailsTrackVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.optionList?.options{
            return list.count
        }else{
            INotifications.show(message: TITLE.customer_noData_available.localized)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTractTableViewCell.cellIdentifier(), for: indexPath) as! DetailTractTableViewCell
        
        if let optionList = self.optionList?.options?[indexPath.row]{
            if !optionList.title.isEmpty{
                cell.nameTxtLbl.text = optionList.title
            }
            
            if !optionList.value.isEmpty{
                
                if optionList.value.contains("http"){
                    let imageUrlString = URL.init(string: optionList.value)
                    cell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                    cell.imgView.isHidden = false
                    cell.valLabel.isHidden = true
                }else{

                    cell.imgView.isHidden = true
                    cell.valLabel.isHidden = false
                    cell.valLabel.text = optionList.value
                }
               // cell.valLabel.text = optionList.value
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTrackHeaderTableViewCell.cellIdentifier()) as! DetailTrackHeaderTableViewCell
        
        if let optionList = self.optionList{
            cell.measurementTypeValLbl.text = optionList.measurement_type
            cell.modelTypeValLbl.text = optionList.model_type
            cell.nameTypeValLbl.text = optionList.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if self.optionList?.options?[indexPath.row].value.contains("http") ?? true{
            return 100
        }else{
          return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let list = self.optionList?.options{
            if list.count > 0{
                return 140
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
}

