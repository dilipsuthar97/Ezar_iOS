//
//  SelectMeasurementVC.swift
//  EZAR
//
//  Created by Volkoff on 18/08/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit
import PanModal

protocol SelectMeasurementViewDelegate {
    func onClickRefreshView()
    func onClickMeasurementTableCell(index: Int)
}

class SelectMeasurementVC: UIViewController {

    var broadcast_request_id: Int?
    var request_id: Int?
    var measurement_status: String?

    var delegate: SelectMeasurementViewDelegate?
    
    var listArray = [
        keyValueData(title: "customer_my_previous_measurement",
                     key: SelectMeasurementStatus.previousMeasurement.key),
        keyValueData(title: "customer_request_delegate",
                     key: SelectMeasurementStatus.requestDelegate.key),
        keyValueData(title: "customer_scan_body",
                     key: SelectMeasurementStatus.scanBody.key),
        keyValueData(title: "customer_tailor_measurement",
                     key: SelectMeasurementStatus.tailorMeasurement.key)
    ]
    
    let viewModel : BroadCastViewModel = BroadCastViewModel()
    var viewHeight = 320
    
    // MARK: - IBOutlet
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
    private func configureUI() {
        titleLbl.text = "customer_take_measurements".localized.uppercased()
        
        // removed if disable from backend
        if LocalDataManager.getMyPreviousTailorMeasurementFlag() == 0 {
            listArray = listArray.filter {
                $0.title != "customer_my_previous_measurement"
            }
            viewHeight -= 70
        }

        // removed if disable from backend
        if LocalDataManager.getScanBodyMeasurementFlag() == 0 {
            listArray = listArray.filter {
                $0.title != "customer_scan_body"
            }
            viewHeight -= 70
        }

        // removed if disable from backend
        if LocalDataManager.getMyTailorMeasurementFlag() == 0 {
            listArray = listArray.filter {
                $0.title != "customer_tailor_measurement"
            }
            viewHeight -= 70
        }
    }
    
    private func setupTableView() {
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tblView.registerCellNib(FabricRequestCell.cellIdentifier())
        tblView.reloadData()
    }
}

// MARK: - PanModalPresentable
extension SelectMeasurementVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return tblView
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(CGFloat(viewHeight))
    }

    var showDragIndicator: Bool {
        return false
    }
}


// MARK: - UITableViewDataSource
extension SelectMeasurementVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FabricRequestCell.cellIdentifier()
        ) as? FabricRequestCell else {
            return UITableViewCell()
        }
        
        cell.titleLbl.text = listArray[indexPath.row].title.localized
        cell.cancelButtton.isHidden = true
        cell.cancelButtton.touchUp = { button in
            self.deleteBroadCastRequest()
        }

        if indexPath.row == SelectMeasurementStatus.requestDelegate.key {
            if broadcast_request_id != 0 && request_id == 0 {
                cell.titleLbl.text = "customer_request_already_broadcasted".localized
                let isPedning = measurement_status == RequestDelegateStatus.pending.key
                cell.cancelButtton.isHidden = !isPedning
            }
            else {
                if let measurement_status = measurement_status,
                   measurement_status.isNotEmpty {
                    if measurement_status == RequestDelegateStatus.pending.key {
                        cell.titleLbl.text = "customer_check_delegate_status".localized
                    } else {
                        cell.titleLbl.text = "customer_track_project_delegate".localized
                    }
                }
            }
        }

        cell.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delay(0) {
            self.dismiss(animated: true, completion: nil)
            let key = self.listArray[indexPath.row].key
            self.delegate?.onClickMeasurementTableCell(index: key)
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - API
extension SelectMeasurementVC {
    private func deleteBroadCastRequest() {
        guard let broadcast_request_id = self.broadcast_request_id else {
            return
        }
        
        self.viewModel.broadcast_id = broadcast_request_id
        self.viewModel.deleteBroadCastRequest {
            if self.viewModel.checkStatus == true {
                self.delay(0) {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.onClickRefreshView()
                }
            }
        }
    }
}
