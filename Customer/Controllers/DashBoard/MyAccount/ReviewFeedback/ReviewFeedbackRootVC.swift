//
//  ReviewFeedbackRootVC.swift
//  Customer
//
//  Created by webwerks on 9/19/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewFeedbackRootVC: BaseTabViewController, CAPSPageMenuDelegate
{
    //MARK:- Variable declaration
    var controller1: ReviewFeedbackVC!
    var controller2: ReviewFeedbackVC!
    var controller3: ReviewFeedbackVC!
    
    var viewModel : ReviewRequestViewModel = ReviewRequestViewModel()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getReviewFeedback()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func getReviewFeedback()
    {
        self.viewModel.getReviewFeedback {
            self.setUpPageMenu(self.viewModel.reviewFeedbacks?.product_item_list, seller_list: self.viewModel.reviewFeedbacks?.seller_list, delegate_list: self.viewModel.reviewFeedbacks?.delegate_list, reviewFormat: self.viewModel.reviewFeedbacks?.review_format)
        }
    }
    
    func setUpPageMenu(_ product_item_list : ProductItemList?, seller_list : ManufacturerList?, delegate_list : DelegateList?, reviewFormat : ReviewFormat?)
    {
        controller1 = ReviewFeedbackVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
        controller1.title = FavoriteTabs.products.localized
        controller1.product_item_list = product_item_list
        controller1.reviewFormat = reviewFormat
        controller1.delegate = self
        controller1.parentNavigationController = self.navigationController
        
        controller2 = ReviewFeedbackVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
        controller2.title = FavoriteTabs.delegate.localized
        controller2.delegate_list = delegate_list
        controller2.reviewFormat = reviewFormat
        controller2.delegate = self
        controller2.parentNavigationController = self.navigationController
        
        controller3 = ReviewFeedbackVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
        controller3.title = FavoriteTabs.manufacturer.localized
        controller3.seller_list = seller_list
        controller3.reviewFormat = reviewFormat
        controller3.delegate = self
        controller3.parentNavigationController = self.navigationController
        
        pageMenu = CAPSPageMenu(viewControllers: [controller1, controller2, controller3], frame: pageMenuFrame, pageMenuOptions: parameters, isFromFavorite : true )
        
        pageMenu?.delegate = self
        pageMenu?.view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        
        controller3.capsPageMenu = pageMenu
        controller2.capsPageMenu = pageMenu
        controller1.capsPageMenu = pageMenu
        
        pageMenu!.controllerScrollView.isScrollEnabled = true
        pageMenu!.menuScrollView.isScrollEnabled = true
        self.view.addSubview(pageMenu!.view)
    }
    
    //MARK:- Helpers for data & UI
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.feedbackAndReview.localized
    }
}

extension ReviewFeedbackRootVC : ReviewFeedbackDelegate
{
    func getReviewFeedbackPagination(_ reviewType: ReviewType, currentPage: Int)
    {
        self.viewModel.reviewType = reviewType.rawValue
        self.viewModel.current_page = currentPage
        self.viewModel.getReviewFeedbackPagination {
      
            switch reviewType
            {
            case .Product:
                if self.viewModel.reviewFeedbacksPagination?.product_item_list?.product_list.count ?? 0 > 0
                {
                    self.controller1.product_item_list?.current_page = self.viewModel.reviewFeedbacksPagination?.product_item_list?.current_page ?? 1
                    self.controller1.product_item_list?.page_count = self.viewModel.reviewFeedbacksPagination?.product_item_list?.page_count ?? 1
                    self.controller1.product_item_list?.product_list.append(contentsOf: self.viewModel.reviewFeedbacksPagination?.product_item_list?.product_list ?? [])
                    self.controller1.tableView.reloadData()
                }
            case .Seller:
                if self.viewModel.reviewFeedbacksPagination?.seller_list?.seller_list.count ?? 0 > 0
                {
                    self.viewModel.reviewFeedbacks?.seller_list?.seller_list.append(contentsOf: self.viewModel.reviewFeedbacksPagination?.seller_list?.seller_list ?? [])
                }
            case .Delegate:
                if self.viewModel.reviewFeedbacksPagination?.delegate_list?.delegate_list.count ?? 0 > 0
                {
                    self.viewModel.reviewFeedbacks?.delegate_list?.delegate_list.append(contentsOf: self.viewModel.reviewFeedbacksPagination?.delegate_list?.delegate_list ?? [])
                }
            case .Fabric:
                break
            }
        }
    }
}
