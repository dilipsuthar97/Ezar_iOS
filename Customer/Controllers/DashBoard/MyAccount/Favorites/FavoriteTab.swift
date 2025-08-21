//
//  FavoriteTab.swift
//  Business
//
//  Created by Volkoff on 28/04/22.
//

import UIKit
import XLPagerTabStrip

class FavoriteTab: ButtonBarPagerTabStripViewController {
        
    lazy var viewModel =  FavoriteViewModel()

    var childVC: [FavoriteVC] = []
    let dataArray = [FavoriteTabs.products.localized, FavoriteTabs.manufacturer.localized, FavoriteTabs.delegate.localized]

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
        COMMON_SETTING.favoriteIndex = 0

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
        getWishList()
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
        self.moveToViewController(at: COMMON_SETTING.favoriteIndex, animated: true)
        self.delay(0) {
            self.updateContent()
        }
    }
        
    func setupNavigation()  {
        navigationItem.title = TITLE.Favorite.localized
        setNavigationBarHidden(hide: false)
        setLeftButton()
    }
    
    //MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        childVC.removeAll()
        for i in 0..<self.dataArray.count {
            let vc = FavoriteVC(nibName: String(describing: FavoriteVC.self), bundle: nil)
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
                    COMMON_SETTING.favoriteIndex = toIndex
                    let vc = self.childVC[COMMON_SETTING.favoriteIndex]
                    vc.viewModel = self.viewModel
                    
                    vc.products = self.viewModel.favoriteObject?.products
                    vc.manufacturers = self.viewModel.favoriteObject?.sellers
                    vc.delegates = self.viewModel.favoriteObject?.delegates
                    vc.changeView()
                }
            }
        }
    }
}

extension FavoriteTab {
    private func getWishList() {
        self.viewModel.getWishList {
            let vc = self.childVC[COMMON_SETTING.favoriteIndex]
            vc.viewModel = self.viewModel
            vc.products = self.viewModel.favoriteObject?.products
            vc.manufacturers = self.viewModel.favoriteObject?.sellers
            vc.delegates = self.viewModel.favoriteObject?.delegates
            vc.changeView()
        }
    }
}
