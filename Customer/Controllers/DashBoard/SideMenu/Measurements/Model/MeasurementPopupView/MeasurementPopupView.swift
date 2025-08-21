//
//  MeasurementPopupView.swift
//  Customer
//
//  Created by Priyanka Jagtap on 23/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup

protocol MeasurementPopUpDelegate{
    
    func onClickCloseInfoBtn()
}

class MeasurementPopupView: UIViewController {
    fileprivate let reuseIdentifier = "PopupTableCell"

    var delegate: MeasurementPopUpDelegate? = nil
    var infoList : [NEMeasurementInfo] = []
    @IBOutlet weak var closeInfoButton: ActionButton!{
        didSet{
            closeInfoButton.layer.masksToBounds = true
            closeInfoButton.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var cancelButton: ActionButton!

    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.popupController?.navigationBarHidden = true
        //setup Tableview
        tableView.register(UINib(nibName: "PopupTableCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
       // tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 60
        closeInfoButton.setTitle(TITLE.customer_info_minus.localized, for: .normal)
        
        closeInfoButton?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.onClickCloseInfoBtn()
        }
        
        cancelButton?.touchUp = { button in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension MeasurementPopupView : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PopupTableCell
        let item = infoList[indexPath.row]
        cell.paramsLabel.text = item.name
        cell.imgView.isHidden = true
        cell.sizeLabel.isHidden = false
        if item.name.contains("Angle") {
            cell.sizeLabel.text = String(format: "%0.2f", item.value) + "°"
        } else {
            cell.sizeLabel.text = "\(String(format: "%0.2f",item.value * 100)) cm"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 24
    }
}
