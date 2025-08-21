//
//  OrderVC.swift
//  Customer
//
//  Created by Webwerks on 9/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import EmptyStateKit
import XLPagerTabStrip


class OrderVC: BaseViewController, IndicatorInfoProvider {

    //MARK: - Variable
    var viewModel: OrderViewModel = OrderViewModel()
    var productType : ProductType = .All

    var custommadeOrders: OrdersData? = nil
    var readymadeOrders: OrdersData? = nil
    var allOrders: OrdersData? = nil
    
    var pageIndex = 0
    var currentPage = 1
    
    @IBOutlet weak var tableView: UITableView?

    var itemInfo = IndicatorInfo(title: "View")
    var params: NSMutableDictionary? = nil
    func setup(itemInfo: IndicatorInfo, params: NSDictionary?) {
        self.itemInfo = itemInfo
        if let params = params{
            self.params = NSMutableDictionary()
            self.params?.addEntries(from: params as! [AnyHashable: Any])
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addPullToRefresh()
        setupEmptyStateView()
    }
    
    func getOrdersAPI() {
        getAllOrdersWS()
    }
    
    func changeView() {
        if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
            self.productType = .All
        }
        if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
            self.productType = .ReadyMade
        }
        if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
            self.productType = .CustomMade
        }
        reloadTableView()
    }
    
    func setupTableView() {
        tableView?.registerCellNib(OrderStausCell.cellIdentifier())
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 200
        tableView?.separatorStyle = .none
    }
}


// MARK: - addPullToRefresh
extension OrderVC {
    private func addPullToRefresh() {
        tableView?.es.addPullToRefresh {
            if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
                self.viewModel.getAllOrders {
                    self.allOrders = self.viewModel.allOrders
                    self.reloadTableView()
                }
            }
            
            if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
                self.viewModel.getOrders {
                    self.readymadeOrders = self.viewModel.orders?.readymadeOrders
                    self.reloadTableView()
                }
            }
            
            if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
                self.viewModel.getOrders {
                    self.custommadeOrders = self.viewModel.orders?.custommadeOrders
                    self.reloadTableView()
                }
            }
        }
    }
}

// MARK: - EmptyStateDelegate

extension OrderVC: EmptyStateDelegate {
    private func setupEmptyStateView() {
        tableView?.emptyState.format = TableState.noResult.format
        tableView?.emptyState.delegate = self
    }

    private func reloadTableView() {
        tableView?.emptyState.hide()
        tableView?.es.stopPullToRefresh()

        if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
            if allOrders?.products.count == 0 {
                tableView?.emptyState.show(TableState.noResult)
            }
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
            if readymadeOrders?.products.count == 0 {
                tableView?.emptyState.show(TableState.noResult)
            }
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
            if custommadeOrders?.products.count == 0 {
                tableView?.emptyState.show(TableState.noResult)
            }
        }

        tableView?.reloadData()
    }

    func emptyState(emptyState _: EmptyState, didPressButton _: UIButton) {}
}

//MARK: - UITableViewDataSource
extension OrderVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
            return allOrders?.products.count ?? 0
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
            return readymadeOrders?.products.count ?? 0
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
            return custommadeOrders?.products.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderStausCell.cellIdentifier(), for: indexPath) as! OrderStausCell
        cell.selectionStyle = .none
        var order : CustomReadyMadeOrder?
        if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
            order = allOrders?.products[indexPath.row]
        }
        if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
            order = readymadeOrders?.products[indexPath.row]
        }
        if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
            order = custommadeOrders?.products[indexPath.row]
        }
        if order?.status == TITLE.customer_delivered_status.localized {
            cell.imgViewOrderStatusWidth.constant = 30.0
            cell.imgViewOrderStatus.image = UIImage.init(named: "checkmark")
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = Theme.greenColor
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }else if order?.status == TITLE.customer_track_status_complete.localized {
            cell.imgViewOrderStatusWidth.constant = 0.0
            cell.imgViewOrderStatus.image = nil
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = UIColor.brown
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }else if order?.status == TITLE.customer_track_status_processing.localized{
            cell.imgViewOrderStatusWidth.constant = 0.0
            cell.imgViewOrderStatus.image = nil
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = UIColor.blue
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }else if order?.status == TITLE.customer_track_status_refunded.localized{
            cell.imgViewOrderStatusWidth.constant = 0.0
            cell.imgViewOrderStatus.image = nil
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = UIColor.darkGray
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }else if order?.status == TITLE.customer_track_status_shipped.localized{
            cell.imgViewOrderStatusWidth.constant = 0.0
            cell.imgViewOrderStatus.image = nil
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = Theme.orageColor
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }else if order?.status == TITLE.customer_close.localized{
            cell.imgViewOrderStatusWidth.constant = 0.0
            cell.imgViewOrderStatus.image = nil
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = UIColor.purple
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }else{
            cell.imgViewOrderStatusWidth.constant = 0.0
            cell.imgViewOrderStatus.image = nil
            cell.lblOrderStatus.textColor = UIColor.white
            cell.lblOrderStatus.backgroundColor = UIColor.red
            cell.lblOrderStatus.layer.cornerRadius = 10
            cell.lblOrderStatus.layer.masksToBounds = true
        }
        
        cell.lblOrderStatus.text = order?.status
        cell.lblOrderDate.text = order?.created_at
        cell.lblOrderId.text = String(format: "#%d", order?.order_increment_id ?? 00)
        cell.lblNoOfProducts.text = String(format: "%d", order?.no_of_products ?? 0)
        
        if let totalAmount = order?.total{
            let amount = Double(totalAmount)
            cell.lblTotal.text = String(format: "%@ %.2f",
                                        order?.currency_symbol ?? "",
                                        amount ?? "0.00")
        }
        let workingDays = order?.group.uppercased().contains("TAILORS") ?? true ? "" : TITLE.customer_working_days.localized
        cell.lblDeliveryDate.text = String(format: "%@ %@", order?.delivery_date ?? "", workingDays)
        cell.lblPaymentMode.text = order?.payment_mode
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        var order : CustomReadyMadeOrder?
        if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
            order = allOrders?.products[indexPath.row]
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
            order = readymadeOrders?.products[indexPath.row]
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
            order = custommadeOrders?.products[indexPath.row]
        }
        
        let vc = OrderTrackingVC.loadFromNib()
        vc.order = order
        if let type = order?.group{
            vc.productType = type
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = tableView else {
            return
        }
        
        let tableHeight = tableView.bounds.size.height
        let contentHeight = tableView.contentSize.height
        let insetHeight = tableView.contentInset.bottom
        
        let yOffset = tableView.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        if (yOffsetAtBottom >= contentHeight) {
            var currentPage : Int = 1
            
            if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
                currentPage =  allOrders?.page_count != allOrders?.current_page ? (allOrders?.current_page ?? 1) + 1 : 0
            }
            
            if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
                currentPage = readymadeOrders?.page_count != readymadeOrders?.current_page ? (readymadeOrders?.current_page ?? 1) + 1 : 0
            }
            
            if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
                currentPage = custommadeOrders?.page_count != custommadeOrders?.current_page ? (custommadeOrders?.current_page ?? 1) + 1 : 0
            }

            if currentPage > 0 {
                self.getOrderListPagination(currentPage: currentPage)
            }
        }
    }
}

//MARK: - API CALL
extension OrderVC {
    private func getAllOrdersWS() {
        self.viewModel.getAllOrders {
            self.allOrders = self.viewModel.allOrders
            self.custommadeOrders = self.viewModel.orders?.custommadeOrders
            self.readymadeOrders = self.viewModel.orders?.readymadeOrders
            self.reloadTableView()
        }
    }
    
    func getOrderListPagination(currentPage: Int) {
        self.viewModel.productType = self.productType.rawValue
        self.viewModel.currentPage = currentPage
      
        if COMMON_SETTING.orderIndex == ORDER_INDEX.all {
            self.viewModel.getAllOrders {
                if self.viewModel.allOrders?.products.count ?? 0 > 0 {
                    self.allOrders?.current_page = currentPage
                    self.allOrders?.products.append(contentsOf: self.viewModel.allOrders?.products ?? [])
                    self.reloadTableView()
                }
            }
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.readymade {
            self.viewModel.getOrders {
                if self.viewModel.orders?.readymadeOrders?.products.count ?? 0 > 0 {
                    self.readymadeOrders?.current_page = currentPage
                    self.readymadeOrders?.products.append(contentsOf:  self.viewModel.orders?.readymadeOrders?.products ?? [])
                    self.reloadTableView()
                }
            }
        }
        
        if COMMON_SETTING.orderIndex == ORDER_INDEX.custommade {
            self.viewModel.getOrders {
                if self.viewModel.orders?.custommadeOrders?.products.count ?? 0 > 0 {
                    self.custommadeOrders?.current_page = currentPage
                    self.custommadeOrders?.products.append(contentsOf:  self.viewModel.orders?.custommadeOrders?.products ?? [])
                    self.reloadTableView()
                }
            }
        }
    }
}
