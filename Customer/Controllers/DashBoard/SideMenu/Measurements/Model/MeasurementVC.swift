//
//  MeasurementVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 23/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup

class MeasurementVC: BaseViewController {
    
    //MARK : Variable Declaration
    fileprivate let reuseIdentifier = "MeasurementTableCell"
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : PreviousviewMeasurementViewModel = PreviousviewMeasurementViewModel()
    var productId : Int = 0
    var footerView : UIView!
    var isProfileMeasurement : Bool = false
    
    //MARK : ViewCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
         configUI()
        
        if isProfileMeasurement {
            
            let button = UIButton()
            button.frame = CGRectMake(0, 0, 51, 31) //won't work if you don't set frame
            button.setImage(UIImage(named: "AddNew"), for: .normal)
            button.addTarget(self, action: #selector(addNewMeasure), for: .touchUpInside)
            
            let barButton = UIBarButtonItem()
            barButton.customView = button
            self.navigationItem.rightBarButtonItem = barButton
            
            /*let button =  UIButton(type: .custom)
              button.setImage(UIImage(named: "payment"), for: .normal)
              button.addTarget(self, action: #selector(addNewMeasure), for: .touchUpInside)
              button.frame = CGRect(x: 0, y: 0, width: 20, height: 31)
              button.imageEdgeInsets = UIEdgeInsetsMake(-1, 32, 1, -32)//move image to the right
              let label = UILabel(frame: CGRect(x: 3, y: 5, width: 20, height: 20))
              label.font = UIFont(name: "Arial-BoldMT", size: 16)
              label.text = "Add"
              label.textAlignment = .center
              label.textColor = .white
              label.backgroundColor =  .clear
              button.addSubview(label)
              let barButton = UIBarButtonItem(customView: button)
              self.navigationItem.rightBarButtonItem = barButton*/
            
            
            //let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeasure))
            //self.navigationItem.rightBarButtonItem = add
        }
    }
    
    @objc func addNewMeasure(){
        let vc = BodyDetailVC.loadFromNib()
        COMMON_SETTING.backToM = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        COMMON_SETTING.backToM = false
    
        if isProfileMeasurement{
            getMeasurementWS()
        } else {
            getPreviousMeasurementWS()
        }
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.prevMeasurement.localized
        
        tableView.register(UINib(nibName: "MeasurementTableCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 162
    }
}


extension MeasurementVC : UITableViewDataSource,UITableViewDelegate{
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.previousMeasurementList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MeasurementTableCell
        cell.selectionStyle = .none
        let previousMeasurement = self.viewModel.previousMeasurementList![indexPath.row]
        
        cell.measuredByLabel.text = isProfileMeasurement ? previousMeasurement.title : previousMeasurement.title
        cell.dateLabel.text = isProfileMeasurement ? previousMeasurement.created_at : previousMeasurement.updated_at
        cell.measurementLbl.text = previousMeasurement.measurement_type
        cell.thobeTypeLbl.text = previousMeasurement.model_type
        cell.sizeLabel.text = previousMeasurement.selected_type_type
        
        if isProfileMeasurement == true{
            cell.selectSizeButton.setImage(UIImage(named: "Delete"), for: .normal)
            cell.selectSizeButton.tintColor = UIColor.red
        } else {
            cell.selectSizeButton.setTitle("Select", for: .normal)
            cell.selectSizeButton.setTitleColor(Theme.orageColor, for: .normal)
        }
        
        if previousMeasurement.selected_type_type == "Perfect"{
            cell.sizeLabel.textColor = Theme.greenColor
            cell.sizeLabel.backgroundColor = Theme.greenBgColor
            cell.sizeLabel.layer.borderColor = Theme.greenColor.cgColor
        }else{
            cell.sizeLabel.textColor = Theme.orageColor
            cell.sizeLabel.backgroundColor = Theme.orageBgColor
            cell.sizeLabel.layer.borderColor = Theme.orageColor.cgColor
        }
        
        
        cell.selectSizeButton.touchUp = { button in
            if self.isProfileMeasurement == true {
                self.deleteMeasurement(id: previousMeasurement.measurement_id)
            } else {
                let previousMeasurement = self.viewModel.previousMeasurementList![indexPath.row]
                self.viewModel.measurement_id = previousMeasurement.measurement_id
                self.viewModel.note = ""
                self.updatePreviousMeasurementWS()
            }
        }

        cell.infoButton.touchUp = { button in
            let controller = MeasurementPopupView.init(nibName: "MeasurementPopupView", bundle: nil)
            //controller.delegate = self
            controller.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 300)
            controller.infoList = previousMeasurement.measurement_Info
            
            let popupController = STPopupController.init(rootViewController: controller)
            popupController.transitionStyle = .fade
            popupController.containerView.backgroundColor = UIColor.clear
            popupController.backgroundView?.backgroundColor = UIColor.black
            popupController.backgroundView?.alpha = 0.7
            popupController.hidesCloseButton = true
            popupController.navigationBarHidden = true
            popupController.present(in: self)
        }
//        if !isProfileMeasurement
//        {
//            self.tableView.tableFooterView = self.viewForFooterInTableView(yPosition: 0.0)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.navigationController?.popViewController(animated: true)
        if !isProfileMeasurement
        {
            let previousMeasurement = self.viewModel.previousMeasurementList![indexPath.row]
            self.viewModel.measurement_id = previousMeasurement.measurement_id
            self.viewModel.note = ""
            updatePreviousMeasurementWS()
        }
    }
    
    func viewForFooterInTableView(yPosition : CGFloat) -> UIView
    {
        if self.footerView == nil
        {
            self.footerView = UIView(frame: CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.size.width, height: 40))
            self.footerView.backgroundColor = Theme.blackColor
            
            let lButton = ActionButton(type: .custom)
            lButton.setTitleColor(Theme.white, for: .normal)
            lButton.setupAction()
            lButton.titleLabel?.font = UIFont.init(name: CustomFont.FuturanBook.rawValue, size: 16.0)
            lButton.layer.cornerRadius = 5
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect.init(x: (UIScreen.main.bounds.size.width/2) - 100, y: 4, width: 200, height: 32)
            //lButton.sizeToFit()
            lButton.titleLabel?.textAlignment = .center
            lButton.setTitle(TITLE.addNewMeasurement.localized, for: .normal)
            self.footerView.addSubview(lButton)
            
            lButton.touchUp = { button in
                
                let vc : MeasurementTypeVC  = MeasurementTypeVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                vc.viewModel.product_id = self.viewModel.product_id
                vc.viewModel.item_quote_id = self.viewModel.item_quote_id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return self.footerView
    }
}

//Webservice call
extension MeasurementVC{
  
    //Get previous measurement
    func getPreviousMeasurementWS()
    {
        let userProfile = Profile.loadProfile()
        self.viewModel.customer_id = userProfile?.id ?? 0
        self.viewModel.getPreviousMeasurement {
            if self.viewModel.previousMeasurementList?.count == 0
            {
                //self.view.addSubview(self.viewForFooterInTableView(yPosition: 150))
            }
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    
    func getMeasurementWS()
    {
        let userProfile = Profile.loadProfile()
        self.viewModel.customer_id = userProfile?.id ?? 0
        self.viewModel.getMeasurement {
         
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func updatePreviousMeasurementWS() {
        
        self.viewModel.updateMeasurementForCartProduct {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func deleteMeasurement(id: String){
        let alert = UIAlertController(title: TITLE.delete_measure.localized, message: TITLE.delete_this_measure.localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler: { _ in
            self.viewModel.deleteMeasurement(id: id) {
                DispatchQueue.main.async {
                    if self.isProfileMeasurement{
                        self.getMeasurementWS()
                    } else {
                        self.getPreviousMeasurementWS()
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
}

