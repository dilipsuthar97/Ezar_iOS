//
//  MeasurementTypeVC.swift
//  Customer
//
//  Created by webwerks on 6/6/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MeasurementTypeVC: BaseTableViewController {

  //  @IBOutlet weak var tableView: UITableView!
    var viewModel : MeasurementTypeModel = MeasurementTypeModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupTableView()
        getMeasurement()
    }

    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.Measurement.localized
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
         tableView.register(UINib(nibName: BottomButtonTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: BottomButtonTableCell.cellIdentifier())
    }
    
    func getMeasurement()
    {
        self.viewModel.getMeasurement {
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- TableView datasoruce & delegate methods

extension MeasurementTypeVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.measurementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BottomButtonTableCell.cellIdentifier(), for: indexPath) as! BottomButtonTableCell
        
        cell.selectionStyle = .none
        let measurement = self.viewModel.measurementList[indexPath.row]
        
        cell.titleTxtLbl.text = measurement.measurement_label
        //cell.textLabel?.text = measurement.model_label
        
        //15Aprail
//        cell.textLabel?.text = measurement.measurement_label
//
//        cell.textLabel?.textColor = Theme.navBarColor
//        cell.textLabel?.font = UIFont.init(customFont: CustomFont.FuturanM, withSize: 16)
        //15 april
        
        // cell.detailTextLabel?.text = measurement.measurement_label
         //cell.detailTextLabel?.font = UIFont.init(customFont: CustomFont.FuturanM, withSize: 13)
        
            // cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let measurement = self.viewModel.measurementList[indexPath.row]
        let vc = MeasurementDetailVC.loadFromNib()
        vc.viewModel.product_id = self.viewModel.product_id
        vc.viewModel.measurementType = measurement.measurement_id
        vc.viewModel.item_quote_id = self.viewModel.item_quote_id
        vc.viewModel.model_type = Int(measurement.model_id) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
