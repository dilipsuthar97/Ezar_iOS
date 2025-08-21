//
//  RequestFeedbackVC.swift
//  Customer
//
//  Created by webwerks on 26/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

protocol ReviewFeedbackDelegate
{
    func getReviewFeedbackPagination(_ reviewType : ReviewType, currentPage : Int)
}

class ReviewFeedbackVC: BaseTableViewController {

    //MARK:- Variable declaration
    var delegate : ReviewFeedbackDelegate!
    var product_item_list   : ProductItemList?
    var seller_list         : ManufacturerList?
    var delegate_list       : DelegateList?
    var reviewFormat        : ReviewFormat?
    //var currentPage : Int = 1
    
    var parentNavigationController : UINavigationController?
    var capsPageMenu:CAPSPageMenu?
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        if product_item_list?.product_list.count == 0{
            INotifications.show(message: TITLE.customer_no_reviews.localized)
        }else if delegate_list?.delegate_list.count == 0{
            INotifications.show(message: TITLE.customer_no_reviews.localized)
        }else if seller_list?.seller_list.count == 0{
            INotifications.show(message: TITLE.customer_no_reviews.localized)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ReviewFeedbackCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReviewFeedbackCell.cellIdentifier())
        tableView.register(UINib(nibName: ManufacturerCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ManufacturerCell.cellIdentifier())
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }

}
//MARK:- TableView datasoruce & delegate methods

extension ReviewFeedbackVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.title
        {
        case FavoriteTabs.products.localized:
            return product_item_list?.product_list.count ?? 0 > 0 ? product_item_list?.product_list.count ?? 0 : 0
        case FavoriteTabs.delegate.localized:
            return delegate_list?.delegate_list.count ?? 0 > 0 ? delegate_list?.delegate_list.count ?? 0 : 0
        case FavoriteTabs.manufacturer.localized:
            return seller_list?.seller_list.count ?? 0 > 0 ? seller_list?.seller_list.count ?? 0 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.title == FavoriteTabs.delegate.localized || self.title == FavoriteTabs.manufacturer.localized
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewFeedbackCell.cellIdentifier(), for: indexPath) as! ReviewFeedbackCell
            cell.selectionStyle = .none
            
           cell.deliveredImgView.isHidden = true
           cell.deliveredDateLbl.isHidden = true
           cell.deliveredLbl.isHidden = true
           cell.paymentModeLbl.isHidden = true
           cell.codeLbl.isHidden = true

            var name = ""
            var logo = ""

            if self.title == FavoriteTabs.delegate.localized
            {
                let modelObject = delegate_list?.delegate_list[indexPath.row]
                name = modelObject?.name ?? ""
                logo = modelObject?.logo ?? ""
            }
            else
            {
                let modelObject = seller_list?.seller_list[indexPath.row]
                name = modelObject?.name ?? ""
                logo = modelObject?.logo ?? ""
            }

            let imageUrlString = URL.init(string: logo)
            cell.reviewImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil,

                                                 completed: nil)
            cell.thoabLbl.text = name

            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier:   ReviewFeedbackCell.cellIdentifier(), for: indexPath) as! ReviewFeedbackCell
        cell.selectionStyle = .none
        
        let modelObject = product_item_list?.product_list[indexPath.row]
        
        cell.deliveredLbl.text = modelObject?.order_status ?? ""
        cell.deliveredDateLbl.text = modelObject?.updated_at ?? ""
        let imageUrlString = URL.init(string: modelObject?.image ?? "")
        cell.reviewImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        cell.thoabLbl.text = modelObject?.name ?? ""
        cell.paymentModeLbl.text = modelObject?.payment_mode ?? ""
       // cell.paymentModeLbl.text = String(modelObject?.order_increment_id ?? 0)
        cell.codeLbl.text = String(format: "%@ %@", modelObject?.currency_symbol ?? "", modelObject?.price ?? "")
        if product_item_list?.product_list[indexPath.row].order_status == TITLE.customer_delivered_status.localized{
            cell.reviewBtn.isHidden = false
            cell.deliveredImgView.isHidden = false
            cell.deliveredImgViewWidth.constant = 40
        }else{
             cell.reviewBtn.isHidden = true
             cell.deliveredImgView.isHidden = true
             cell.deliveredImgViewWidth.constant = 0
        }
//        cell.deliveredImgView.isHidden = true
//        cell.reviewBtn.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ReviewViewController.loadFromNib()
        
        switch self.title {
        case FavoriteTabs.products.localized:
            let modelObject = product_item_list?.product_list[indexPath.row]
            vc.viewModel.review_type = modelObject?.product_type.uppercased() == "F" ? ReviewType.Fabric.rawValue : ReviewType.Product.rawValue
            vc.viewModel.anyObject = modelObject as AnyObject
            vc.initializeArray(reviewQuestions: modelObject?.product_type.uppercased() == "F" ? reviewFormat?.fabric ?? [] : reviewFormat?.product ?? [])
            vc.viewModel.key_id = "product_id"
            vc.viewModel.order_item_id = modelObject?.id ?? 0
            vc.viewModel.value_id = modelObject?.product_id ?? 0
            vc.viewModel.review_id = modelObject?.rating_and_reviews?.review_id ?? 0
            vc.viewModel.reviewRating = modelObject?.rating_and_reviews?.rating ?? ""
            vc.viewModel.title = modelObject?.rating_and_reviews?.review_title ?? ""
            vc.viewModel.detailDescription = modelObject?.rating_and_reviews?.review_description ?? ""
            
            if let questionAns = modelObject?.rating_and_reviews?.question_answers{
                vc.viewModel.questionAnswer = questionAns
                print(questionAns)
            }
            
            vc.type = FavoriteTabs.products.localized
        case FavoriteTabs.delegate.localized:
            vc.viewModel.review_type = ReviewType.Delegate.rawValue
            vc.viewModel.anyObject = delegate_list?.delegate_list[indexPath.row] as AnyObject
            vc.initializeArray(reviewQuestions: reviewFormat?.delegate ?? [])
            vc.viewModel.key_id = "delegate_id"
            vc.viewModel.value_id = delegate_list?.delegate_list[indexPath.row].id ?? 0
            vc.viewModel.review_id = delegate_list?.delegate_list[indexPath.row].rating_and_reviews?.review_id ?? 0
            vc.viewModel.reviewRating = delegate_list?.delegate_list[indexPath.row].rating_and_reviews?.rating ?? ""
            vc.viewModel.title = delegate_list?.delegate_list[indexPath.row].rating_and_reviews?.review_title ?? ""
            vc.viewModel.detailDescription = delegate_list?.delegate_list[indexPath.row].rating_and_reviews?.review_description ?? ""
            vc.type = FavoriteTabs.delegate.localized
            self.parentNavigationController?.pushViewController(vc, animated: true)
        case FavoriteTabs.manufacturer.localized:
            vc.viewModel.review_type = ReviewType.Seller.rawValue
            vc.viewModel.anyObject = seller_list?.seller_list[indexPath.row] as AnyObject
            vc.initializeArray(reviewQuestions: reviewFormat?.seller ?? [])
            vc.viewModel.key_id = "seller_id"
            vc.viewModel.value_id = seller_list?.seller_list[indexPath.row].id ?? 0
            vc.viewModel.review_id = seller_list?.seller_list[indexPath.row].rating_and_reviews?.review_id ?? 0
            vc.viewModel.reviewRating = seller_list?.seller_list[indexPath.row].rating_and_reviews?.rating ?? ""
            vc.viewModel.title = seller_list?.seller_list[indexPath.row].rating_and_reviews?.review_title ?? ""
            vc.viewModel.detailDescription = seller_list?.seller_list[indexPath.row].rating_and_reviews?.review_description ?? ""
            vc.type = FavoriteTabs.manufacturer.localized
            self.parentNavigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
        if product_item_list?.product_list[indexPath.row].order_status == TITLE.customer_delivered_status.localized{
            self.parentNavigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let tableHeight = tableView.bounds.size.height
        let contentHeight = tableView.contentSize.height
        let insetHeight = tableView.contentInset.bottom
        
        let yOffset = tableView.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        if (yOffsetAtBottom >= contentHeight)
        {
            var currentPage : Int = 1
            var reviewType : ReviewType = .Product
            switch self.title
            {
            case FavoriteTabs.products.localized:
                currentPage =  product_item_list?.page_count != product_item_list?.current_page ? (product_item_list?.current_page ?? 1) + 1 : 0
                reviewType = .Product
            case FavoriteTabs.delegate.localized:
                currentPage = delegate_list?.page_count != delegate_list?.current_page ? (product_item_list?.current_page ?? 1) + 1 : 0
                reviewType = .Delegate
            case FavoriteTabs.manufacturer.localized:
                currentPage = seller_list?.page_count != seller_list?.current_page ? (product_item_list?.current_page ?? 1) + 1 : 0
                reviewType = .Seller
            default:
                break
            }
            if currentPage > 0
            {
                self.delegate.getReviewFeedbackPagination(reviewType, currentPage: currentPage)
            }
        }
    }
}
