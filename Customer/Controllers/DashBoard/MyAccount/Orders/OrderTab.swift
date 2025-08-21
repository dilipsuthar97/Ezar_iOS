//
//  MenuTab.swift
//  Business
//
//  Created by Volkoff on 28/04/22.
//

import UIKit
import XLPagerTabStrip

class OrderTab: ButtonBarPagerTabStripViewController {
        
    var viewModel: OrderViewModel = OrderViewModel()

    var childVC: [OrderVC] = []
    let dataArray = [OrderTabs.all.localized, OrderTabs.readymade.localized, OrderTabs.custommade.localized]

    //MARK: - IBOutlet
    @IBOutlet var scroView: UIScrollView!
    @IBOutlet var TabWidth: NSLayoutConstraint!

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = Theme.primaryColor
        settings.style.buttonBarItemFont = FontType.regular(size: 16)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemTitleColor = UIColor.gray
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 0
        COMMON_SETTING.orderIndex = 0

        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?,
                                          newCell: ButtonBarViewCell?,
                                          progressPercentage: CGFloat,
                                          changeCurrentIndex: Bool,
                                          animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.gray
            newCell?.label.textColor = Theme.primaryColor
        }
        
        super.viewDidLoad()
        let vc = self.childVC[COMMON_SETTING.orderIndex]
        vc.getOrdersAPI()
        getOrdersWS()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.moveToViewController(at: COMMON_SETTING.orderIndex, animated: true)
        self.delay(0) {
            self.updateContent()
        }
    }
        
    func setupNavigation()  {
        navigationItem.title = TITLE.Orders.localized
        setNavigationBarHidden(hide: false)
        setLeftButton()
    }
    
    //MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        childVC.removeAll()
        for i in 0..<self.dataArray.count {
            let vc = OrderVC(nibName: String(describing: OrderVC.self), bundle: nil)
            vc.setup(itemInfo: IndicatorInfo(title: self.dataArray[i]), params: nil)
            childVC.append(vc)
        }
        return childVC
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController,
                                  fromIndex: Int,
                                  toIndex: Int,
                                  withProgressPercentage progressPercentage: CGFloat,
                                  indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex,
                              toIndex: toIndex,
                              withProgressPercentage: progressPercentage,
                              indexWasChanged: indexWasChanged)
        if progressPercentage > 0 {
            if indexWasChanged {
                self.delay(0) {
                    COMMON_SETTING.orderIndex = toIndex
                    let vc = self.childVC[COMMON_SETTING.orderIndex]
                    vc.custommadeOrders = self.viewModel.orders?.custommadeOrders
                    vc.readymadeOrders = self.viewModel.orders?.readymadeOrders
                    vc.changeView()
                }
            }
        }
    }
}

extension OrderTab {
    private func getOrdersWS() {
        self.viewModel.getOrders { }
    }
}
