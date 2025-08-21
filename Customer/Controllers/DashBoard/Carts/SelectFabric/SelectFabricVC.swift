//
//  SelectFabricVC.swift
//  EZAR
//
//  Created by Volkoff on 18/08/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit
import PanModal

protocol SelectFabricViewDelegate {
    func onClickFabricTableViewCell(index: Int)
    func onClickReloadView()
}

class SelectFabricVC: UIViewController {
    
    var broadcast_request_id: Int?
    var request_id: Int?
    var fabric_status: String?
    
    var listArray = [
        ObjData(title: "customer_choose_fabric_online",
                details: "customer_choose_fabric_online_description",
                key: SelectFabricStatus.fabricOnline.key),
        ObjData(title: "customer_contact_delegate",
                details: "customer_contact_project_delegate_nearby_you",
                key: SelectFabricStatus.contactDelegate.key),
        ObjData(title: "customer_my_own_fabric",
                details: "customer_my_own_fabric_description",
                key: SelectFabricStatus.myOwnFabric.key),
    ]
    
    var viewHeight = 320
    var delegate: SelectFabricViewDelegate?
    let viewModel : BroadCastViewModel = BroadCastViewModel()
    
    
    // MARK: - IBOutlet
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        
        // removed if disable from backend
        if LocalDataManager.getMyOwnFabricSelectionFlag() == 0 {
            listArray = listArray.filter {
                $0.title != "customer_my_own_fabric"
            }
            viewHeight -= 100
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
    private func configureUI() {
        titleLbl.text = "customer_choose_fabric".localized.uppercased()
        
        guard let fabric_status = fabric_status else {
            return
        }
        
        // update lists
        if broadcast_request_id != 0 && request_id == 0 {
            listArray = [ ObjData(title: "customer_choose_fabric_online",
                                  details: "customer_choose_fabric_online_description",
                                  key: SelectFabricStatus.fabricOnline.key),
                          ObjData(title: "customer_request_already_broadcasted",
                                  details: "",
                                  key: SelectFabricStatus.contactDelegate.key),
                          ObjData(title: "customer_my_own_fabric",
                                  details: "customer_my_own_fabric_description",
                                  key: SelectFabricStatus.myOwnFabric.key),
            ]
        } else {

            if fabric_status == RequestDelegateStatus.pending.key {
                listArray = [ ObjData(title: "customer_choose_fabric_online",
                                      details: "customer_choose_fabric_online_description",
                                      key: SelectFabricStatus.fabricOnline.key),
                              ObjData(title: "customer_check_delegate_status",
                                      details: "customer_contact_project_delegate_nearby_you",
                                      key: SelectFabricStatus.contactDelegate.key),
                              ObjData(title: "customer_my_own_fabric",
                                      details: "customer_my_own_fabric_description",
                                      key: SelectFabricStatus.myOwnFabric.key)
                ]
            }
            
            if fabric_status == RequestDelegateStatus.approved.key {
                listArray = [ ObjData(title: "customer_choose_fabric_online",
                                      details: "customer_choose_fabric_online_description",
                                      key: SelectFabricStatus.fabricOnline.key),
                              ObjData(title: "customer_track_project_delegate",
                                      details: "customer_track_delegate_info_for_fabric",
                                      key: SelectFabricStatus.contactDelegate.key),
                              ObjData(title: "customer_my_own_fabric",
                                      details: "customer_my_own_fabric_description",
                                      key: SelectFabricStatus.myOwnFabric.key)
                ]
            }
        }
    }
    
    private func setupTableView() {
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tblView.registerCellNib(SelectFabricCell.cellIdentifier())
        tblView.registerCellNib(FabricRequestCell.cellIdentifier())
        tblView.reloadData()
    }
}

// MARK: - PanModalPresentable
extension SelectFabricVC: PanModalPresentable {
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
extension SelectFabricVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isRequestBroadcast = broadcast_request_id != 0 && request_id == 0
        
        if indexPath.row == 1 && isRequestBroadcast {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FabricRequestCell.cellIdentifier()
            ) as? FabricRequestCell else {
                return UITableViewCell()
            }
            cell.titleLbl.text = listArray[indexPath.row].title.localized

            let isPedning = fabric_status == RequestDelegateStatus.pending.key
            cell.cancelButtton.isHidden = !isPedning
            cell.cancelButtton.touchUp = { button in
                self.deleteBroadCastRequest()
            }
            cell.clipsToBounds = true
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectFabricCell.cellIdentifier()
        ) as? SelectFabricCell else {
            return UITableViewCell()
        }
        
        cell.titleLbl.text = listArray[indexPath.row].title.localized
        cell.detailsLbl.text = listArray[indexPath.row].details.localized
        
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delay(0) {
            self.dismiss(animated: true, completion: nil)
            let key = self.listArray[indexPath.row].key
            self.delegate?.onClickFabricTableViewCell(index: key)
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - API
extension SelectFabricVC {
    private func deleteBroadCastRequest() {
        guard let broadcast_request_id = self.broadcast_request_id else {
            return
        }
        
        self.viewModel.broadcast_id = broadcast_request_id
        self.viewModel.deleteBroadCastRequest {
            if self.viewModel.checkStatus == true {
                self.delay(0) {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.onClickReloadView()
                }
            }
        }
    }
}
