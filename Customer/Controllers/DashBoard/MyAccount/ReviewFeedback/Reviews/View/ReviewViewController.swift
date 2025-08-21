//
//  ReviewViewController.swift
//  Customer
//
//  Created by Priyanka Jagtap on 11/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewViewController: BaseViewController {
    
    @IBOutlet weak var submitButton: ActionButton!
    @IBOutlet weak var skipButton: ActionButton!
    @IBOutlet weak var nextButton: ActionButton!
    @IBOutlet weak var btnsBGView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    var viewModel : ReviewFeedbackViewModel = ReviewFeedbackViewModel()
    var selectedDic : [Int : Int] = [-1 : -1]
    var indexPathArray : [IndexPath] = []
    var ratingVal : String = ""
    var isFromOrderTracking : Bool = false
    var reviewFormat        : ReviewFormat?
    var type : String = ""
    var index : Int?
    var tabButton = false
    //MARK: - DropDown
    let categoryDropDown = DropDown()
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        categoryDropDown.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        categoryDropDown.customCellConfiguration = nil
    }
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupTableView()
        initialize()
        hideKeyboardWhenTappedAround()
        categoryDropDown.dismissMode = .onTap
        categoryDropDown.direction = .any
    }
            
    func configUI() {
        setNavigationBarHidden(hide: false)
        setupUI()
        skipButton.setTitle(TITLE.customer_skip.localized.uppercased(), for: .normal)
        nextButton.setTitle(TITLE.NEXT.localized.uppercased(), for: .normal)
        submitButton.titleLabel?.text = TITLE.Submit.localized
        
        if self.type == FavoriteTabs.products.localized {
             self.headerLabel.text = TITLE.customer_product_feedback.localized
        } else if self.type == FavoriteTabs.delegate.localized {
             self.headerLabel.text = TITLE.customer_feedback_for_delegate.localized
        } else {
             self.headerLabel.text = TITLE.customer_seller_feedback.localized
        }
    }
    
    override func onClickLeftButton(button: UIButton) {
        if self.isFromOrderTracking == true {
            self.backToRootView()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupUI(){
        if self.isFromOrderTracking == true{
            submitButton.isHidden = true
            btnsBGView.isHidden = false
            
            if COMMON_SETTING.productType == ProductType.CustomMade.rawValue{
                if self.viewModel.review_type == ReviewType.Product.rawValue{
                    self.setBackButton()
                    navigationItem.title = TITLE.customer_product_review.localized
                    
                    if COMMON_SETTING.vendorReview == 0{
                        skipButton.isHidden = false
                        
                    }else if COMMON_SETTING.delegateReview == 0{
                        if COMMON_SETTING.delegateId != 0{
                            skipButton.isHidden = false
                        }else{
                        skipButton.isHidden = true
                        }
                    }else{
                        skipButton.isHidden = true
                    }
                    
                }else if (self.viewModel.review_type == ReviewType.Delegate.rawValue){
                    
                    skipButton.isHidden = true
                    self.setBackButton()
                    navigationItem.title = TITLE.customer_delegate_review.localized
                }else if (self.viewModel.review_type == ReviewType.Seller.rawValue){
                    
                    if COMMON_SETTING.delegateReview == 0{
                        if COMMON_SETTING.delegateId != 0{
                            skipButton.isHidden = false
                        }else{
                            skipButton.isHidden = true
                        }
                    }else{
                        skipButton.isHidden = true
                    }
                    
                    self.setBackButton()
                    navigationItem.title = TITLE.customer_seller_review.localized
                    
                }else{
                    self.setBackButton()
                    navigationItem.title = TITLE.customer_product_review.localized

                    if COMMON_SETTING.vendorReview == 0{
                        skipButton.isHidden = false
                        
                    }else if COMMON_SETTING.delegateReview == 0{
                        if COMMON_SETTING.delegateId != 0{
                            skipButton.isHidden = false
                        }else{
                            skipButton.isHidden = true
                        }
                    }else{
                        skipButton.isHidden = true
                    }
                }
            }else{
                if self.viewModel.review_type == ReviewType.Product.rawValue{
                    
                    self.setBackButton()
                    navigationItem.title = TITLE.customer_product_review.localized

                    if COMMON_SETTING.vendorReview == 0{
                        skipButton.isHidden = false
                        
                    }else{
                        skipButton.isHidden = true
                    }
                    
                }else if (self.viewModel.review_type == ReviewType.Seller.rawValue){
                    
                    if COMMON_SETTING.productType == ProductType.CustomMade.rawValue{
                        skipButton.isHidden = false
                        self.setBackButton()
                        navigationItem.title = TITLE.customer_seller_review.localized
                    }else{
                        skipButton.isHidden = true
                        self.setBackButton()
                        navigationItem.title = TITLE.customer_seller_review.localized
                    }
                }
            }
        }else{
            btnsBGView.isHidden = true
            submitButton.isHidden = false
            self.setBackButton()
            navigationItem.title = TITLE.feedbackAndReview.localized
        }
    }
    
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: ReviewRatingCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReviewRatingCell.cellIdentifier())
        tableView.register(UINib(nibName: ReviewTextCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReviewTextCell.cellIdentifier())
        tableView.register(UINib(nibName: ReviewTextAreaCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReviewTextAreaCell.cellIdentifier())
        tableView.register(UINib(nibName: ReviewDropDownCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReviewDropDownCell.cellIdentifier())
        tableView.register(UINib(nibName: ReviewSelectCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReviewSelectCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    func initializeArray(reviewQuestions : [ReviewQuestions])
    {
        let type1 : String = "Rating"
        let type2 : String = "Text"
        let type3 : String = "Textarea"
        
        self.viewModel.reviewQuestions.append(type1 as AnyObject)
        self.viewModel.reviewQuestions.append(type2 as AnyObject)
        self.viewModel.reviewQuestions.append(type3 as AnyObject)
        if reviewQuestions.count > 0
        {
            self.viewModel.reviewQuestions.append(contentsOf: reviewQuestions as [AnyObject])
        }
        
        if isFromOrderTracking == true{
            
            self.viewModel.reviewQuestions.remove(at: 0)
            if self.viewModel.reviewQuestions.count > 0{
                self.viewModel.reviewQuestions.insert(type1 as AnyObject, at:self.viewModel.reviewQuestions.count)
            }
        }
        
    }
    
    func backToRootView(){
        if let viewControllers = self.navigationController?.viewControllers{
            for aViewController in viewControllers {
                if aViewController is OrderTrackingVC {
                    let aVC = aViewController as! OrderTrackingVC
                    _ = self.navigationController?.popToViewController(aVC, animated: true)
                }
            }
        }
    }
    
    func initialize(){
        
        self.submitButton.touchUp = { button in
            self.apicall()
        }
        
        nextButton.touchUp = { button in
            self.apicall()
        }
        
        skipButton.touchUp = { button in
            let vc = ReviewViewController.loadFromNib()
            vc.isFromOrderTracking = true
            if COMMON_SETTING.productType == ProductType.CustomMade.rawValue{
                if self.viewModel.review_type == ReviewType.Product.rawValue{
                    self.setupUI()
                    
                    if COMMON_SETTING.vendorReview == 0{
                        vc.viewModel.review_type = ReviewType.Seller.rawValue
                        vc.viewModel.key_id = "seller_id"
                        
                        if !COMMON_SETTING.sellerId.isEmpty{
                            vc.viewModel.value_id = Int(COMMON_SETTING.sellerId) ?? 0
                        }
                        
                        vc.initializeArray(reviewQuestions: self.reviewFormat?.seller ?? [])
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else if COMMON_SETTING.delegateReview == 0{
                        if COMMON_SETTING.delegateId != 0{
                            vc.viewModel.review_type = ReviewType.Delegate.rawValue
                            vc.viewModel.key_id = "delegate_id"
                            vc.viewModel.value_id = COMMON_SETTING.delegateId
                            vc.initializeArray(reviewQuestions: self.reviewFormat?.delegate ?? [])
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            self.backToRootView()
                        }
                    }else{
                        self.backToRootView()
                    }
                }else if (self.viewModel.review_type == ReviewType.Delegate.rawValue){
                    self.setupUI()
                    
                    if COMMON_SETTING.delegateReview == 0{
                        self.backToRootView()
                    }
                    
                }else if (self.viewModel.review_type == ReviewType.Seller.rawValue){
                    
                    if COMMON_SETTING.delegateReview == 0{
                        if COMMON_SETTING.delegateId != 0{
                            vc.viewModel.review_type = ReviewType.Delegate.rawValue
                            vc.viewModel.key_id = "delegate_id"
                            vc.viewModel.value_id = COMMON_SETTING.delegateId
                            vc.initializeArray(reviewQuestions: self.reviewFormat?.delegate ?? [])
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            self.backToRootView()
                        }
                    }
                }else{
                    self.setupUI()
                    if COMMON_SETTING.vendorReview == 0{
                        vc.viewModel.review_type = ReviewType.Seller.rawValue
                        vc.viewModel.key_id = "seller_id"
                        
                        if !COMMON_SETTING.sellerId.isEmpty{
                            vc.viewModel.value_id = Int(COMMON_SETTING.sellerId) ?? 0
                        }
                        
                        vc.initializeArray(reviewQuestions: self.reviewFormat?.seller ?? [])
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else if COMMON_SETTING.delegateReview == 0{
                        if COMMON_SETTING.delegateId != 0{
                            vc.viewModel.review_type = ReviewType.Delegate.rawValue
                            vc.viewModel.key_id = "delegate_id"
                            vc.viewModel.value_id = COMMON_SETTING.delegateId
                            vc.initializeArray(reviewQuestions: self.reviewFormat?.delegate ?? [])
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            self.backToRootView()
                        }
                    }else{
                        self.backToRootView()
                    }
                }
            }else{
                if self.viewModel.review_type == ReviewType.Product.rawValue{
                    self.setupUI()
                    
                    if COMMON_SETTING.vendorReview == 0{
                        vc.viewModel.review_type = ReviewType.Seller.rawValue
                        vc.viewModel.key_id = "seller_id"
                        
                        if !COMMON_SETTING.sellerId.isEmpty{
                            vc.viewModel.value_id = Int(COMMON_SETTING.sellerId) ?? 0
                        }
                        
                        vc.initializeArray(reviewQuestions: self.reviewFormat?.seller ?? [])
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        self.backToRootView()
                    }
                    
                }else if (self.viewModel.review_type == ReviewType.Seller.rawValue){
                    self.backToRootView()
                }
            }
        }
    }
    
    func apicall(){
        
        for indexPath in self.indexPathArray
        {
            let cellType = self.tableView.cellForRow(at: indexPath)
            let model = self.viewModel.reviewQuestions[indexPath.row]
            if cellType is ReviewRatingCell, let cell : ReviewRatingCell = cellType as? ReviewRatingCell
            {
                self.viewModel.star_rating = Int(cell.ratingView.value)
                
                if !(self.viewModel.star_rating > 0) {
                    INotifications.show(message: TITLE.customer_Rating_Error.localized)
                    return
                }
                print(cell)
            }
            else if cellType is ReviewTextCell, let cell : ReviewTextCell = cellType as? ReviewTextCell
            {
                if model is String
                {
                    self.viewModel.title = cell.titleTextField?.text ?? ""
                    print(model)
                }
                else if model is ReviewQuestions, let modelObj : ReviewQuestions = model as? ReviewQuestions
                {
                    print(modelObj)
                   // self.viewModel.title = cell.titleTextField.text ?? ""
                    let dictionary : NSMutableDictionary = NSMutableDictionary()
                    dictionary.addEntries(from: ["question_id":modelObj.question_id, "question":modelObj.question, "type":modelObj.type, "option_values":modelObj.option_values, "answer":cell.titleTextField?.text ?? ""])
                    self.viewModel.question_answers.append(dictionary)
                }
            }
            else if cellType is ReviewTextAreaCell, let cell : ReviewTextAreaCell = cellType as? ReviewTextAreaCell
            {
                if model is String
                {
                    self.viewModel.detailDescription = cell.detailTextView?.text ?? ""
                    print(model)
                }
                else if model is ReviewQuestions, let modelObj : ReviewQuestions = model as? ReviewQuestions
                {
                    print(modelObj)
                  //  self.viewModel.detailDescription = cell.detailTextView?.text ?? ""
                    let dictionary : NSMutableDictionary = NSMutableDictionary()
                    dictionary.addEntries(from: ["question_id":modelObj.question_id, "question":modelObj.question, "type":modelObj.type, "option_values":modelObj.option_values, "answer":cell.detailTextView.text])
                    self.viewModel.question_answers.append(dictionary)
                }
            }
            else if cellType is ReviewDropDownCell, let cell : ReviewDropDownCell = cellType as? ReviewDropDownCell
            {
                if model is ReviewQuestions, let modelObj : ReviewQuestions = model as? ReviewQuestions
                {
                    print(modelObj)
                    let dictionary : NSMutableDictionary = NSMutableDictionary()
                    dictionary.addEntries(from: ["question_id":modelObj.question_id, "question":modelObj.question, "type":modelObj.type, "option_values":modelObj.option_values, "answer":cell.selectAnswer.text ?? ""])
                    
                    self.viewModel.question_answers.append(dictionary)
                }
            }
            else if cellType is ReviewSelectCell
            {
                if model is ReviewQuestions, let modelObj : ReviewQuestions = model as? ReviewQuestions
                {
                    let value : String = self.selectedDic[indexPath.row] == 1 ? "Yes" : "No"
                    let dictionary : NSMutableDictionary = NSMutableDictionary()
                    dictionary.addEntries(from: ["question_id":modelObj.question_id, "question":modelObj.question, "type":modelObj.type, "option_values":modelObj.option_values, "answer":value])
                    self.viewModel.question_answers.append(dictionary)
                }
            }
        }
        
       // self.viewModel.star_rating
        self.viewModel.setReviewFeedback {
            
            if self.isFromOrderTracking == true{
                if self.viewModel.errorCode != 200{
                    INotifications.show(message: self.viewModel.message)
                }else{
                    let vc = ReviewViewController.loadFromNib()
                    vc.isFromOrderTracking = true
                    
                    if COMMON_SETTING.productType == ProductType.CustomMade.rawValue{
                        
                        if self.viewModel.review_type == ReviewType.Product.rawValue{
                            self.setupUI()
                            
                            if COMMON_SETTING.vendorReview == 0{
                                vc.viewModel.review_type = ReviewType.Seller.rawValue
                                vc.viewModel.key_id = "seller_id"
                                
                                if !COMMON_SETTING.sellerId.isEmpty{
                                    vc.viewModel.value_id = Int(COMMON_SETTING.sellerId) ?? 0
                                }
                                
                                vc.initializeArray(reviewQuestions: self.reviewFormat?.seller ?? [])
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if COMMON_SETTING.delegateReview == 0{
                                if COMMON_SETTING.delegateId != 0{
                                    vc.viewModel.review_type = ReviewType.Delegate.rawValue
                                    vc.viewModel.key_id = "delegate_id"
                                    vc.viewModel.value_id = COMMON_SETTING.delegateId
                                    vc.initializeArray(reviewQuestions: self.reviewFormat?.delegate ?? [])
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{
                                    self.backToRootView()
                                }
                            }else{
                                self.backToRootView()
                            }
                        }else if (self.viewModel.review_type == ReviewType.Delegate.rawValue){
                            self.setupUI()
                            
                            if COMMON_SETTING.delegateReview == 0{
                                self.backToRootView()
                            }
                            
                        }else if (self.viewModel.review_type == ReviewType.Seller.rawValue){
                            
                            if COMMON_SETTING.delegateReview == 0{
                                if COMMON_SETTING.delegateId != 0{
                                    vc.viewModel.review_type = ReviewType.Delegate.rawValue
                                    vc.viewModel.key_id = "delegate_id"
                                    vc.viewModel.value_id = COMMON_SETTING.delegateId
                                    vc.initializeArray(reviewQuestions: self.reviewFormat?.delegate ?? [])
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{
                                    self.backToRootView()
                                }
                            }else{
                                self.backToRootView()
                            }
                        }else{
                            self.setupUI()
                            
                            if COMMON_SETTING.vendorReview == 0{
                                vc.viewModel.review_type = ReviewType.Seller.rawValue
                                vc.viewModel.key_id = "seller_id"
                                
                                if !COMMON_SETTING.sellerId.isEmpty{
                                    vc.viewModel.value_id = Int(COMMON_SETTING.sellerId) ?? 0
                                }
                                
                                vc.initializeArray(reviewQuestions: self.reviewFormat?.seller ?? [])
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if COMMON_SETTING.delegateReview == 0{
                                if COMMON_SETTING.delegateId != 0{
                                    vc.viewModel.review_type = ReviewType.Delegate.rawValue
                                    vc.viewModel.key_id = "delegate_id"
                                    vc.viewModel.value_id = COMMON_SETTING.delegateId
                                    vc.initializeArray(reviewQuestions: self.reviewFormat?.delegate ?? [])
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{
                                    self.backToRootView()
                                }
                            }else{
                                self.backToRootView()
                            }
                        }
                    }else{
                        if self.viewModel.review_type == ReviewType.Product.rawValue{
                            self.setupUI()
                            
                            if COMMON_SETTING.vendorReview == 0{
                                vc.viewModel.review_type = ReviewType.Seller.rawValue
                                vc.viewModel.key_id = "seller_id"
                                
                                if !COMMON_SETTING.sellerId.isEmpty{
                                    vc.viewModel.value_id = Int(COMMON_SETTING.sellerId) ?? 0
                                }
                                
                                vc.initializeArray(reviewQuestions: self.reviewFormat?.seller ?? [])
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else{
                                self.backToRootView()
                            }
                            
                        }else if (self.viewModel.review_type == ReviewType.Seller.rawValue){
                            
                            self.backToRootView()
                        }
                    }
                }
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK:- TableView datasoruce & delegate methods

extension ReviewViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.reviewQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.viewModel.reviewQuestions[indexPath.row]
       
        self.indexPathArray.append(indexPath)
        
        if isFromOrderTracking == true{

             if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextCell.cellIdentifier(), for: indexPath) as! ReviewTextCell
                cell.selectionStyle = .none
                if !(self.viewModel.title.isEmpty)
                {
                    cell.titleTextField.text = self.viewModel.title
                }
                return cell
            }
            else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextAreaCell.cellIdentifier(), for: indexPath) as! ReviewTextAreaCell
                cell.selectionStyle = .none
                cell.detailTextView.addToolBar()
                if !(self.viewModel.detailDescription.isEmpty)
                {
                    cell.detailTextView.text = self.viewModel.detailDescription
                }
                return cell
            }
            else if let modelObj : ReviewQuestions = model as? ReviewQuestions
            {
                if modelObj.type == ReviewQuestionType.Text.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextCell.cellIdentifier(), for: indexPath) as! ReviewTextCell
                    cell.textQuestion.text = modelObj.question
                    cell.selectionStyle = .none
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    if !(obj?.answer.isEmpty ?? true){
                        cell.titleTextField.text = obj?.answer ?? ""
                    }
                    return cell
                }
                else if modelObj.type == ReviewQuestionType.TextArea.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextAreaCell.cellIdentifier(), for: indexPath) as! ReviewTextAreaCell
                    cell.textViewQuestion.text = modelObj.question
                    cell.detailTextView.addToolBar()
                    cell.selectionStyle = .none
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    if !(obj?.answer.isEmpty ?? true){
                        cell.detailTextView.text = obj?.answer ?? ""
                    }
                    return cell
                }
                else if modelObj.type == ReviewQuestionType.Select.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewDropDownCell.cellIdentifier(), for: indexPath) as! ReviewDropDownCell
                    cell.questionTxt.text = modelObj.question
                    cell.selectAnswer.isUserInteractionEnabled = false
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    if !(obj?.answer.isEmpty ?? true){
                        cell.selectAnswer.text = obj?.answer ?? ""
                    }
                    cell.selectionStyle = .none
                    return cell
                }
                else if modelObj.type == ReviewQuestionType.Yes_No.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewSelectCell.cellIdentifier(), for: indexPath) as! ReviewSelectCell
                    cell.questionTxt.text = modelObj.question
                    
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    
                    if !tabButton{
                        if obj?.answer == "Yes"{
                            self.selectedDic = [indexPath.row : 1]
                            
                        }else if obj?.answer == "No"{
                            self.selectedDic = [indexPath.row : 2]
                        }
                    }
                    
                    cell.yesImgView.image = selectedDic[indexPath.row] == 1 ? UIImage.init(named: "radio_selected") : UIImage.init(named: "radio_unselected")
                    cell.noImgView.image = selectedDic[indexPath.row] == 2 ? UIImage.init(named: "radio_selected") : UIImage.init(named: "radio_unselected")
                    cell.selectionStyle = .none

                    cell.yesButton.touchUp = { button in
                         self.tabButton = true
                        self.selectedDic = [indexPath.row : 1]
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    cell.noButton.touchUp = { button in
                         self.tabButton = true
                        self.selectedDic = [indexPath.row : 2]
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    return cell
                }
             }else if indexPath.row == self.viewModel.reviewQuestions.count - 1
             {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewRatingCell.cellIdentifier(), for: indexPath) as! ReviewRatingCell
                cell.selectionStyle = .none
                cell.headerLabel.isHidden = false
                if self.viewModel.review_id != 0, !(self.viewModel.reviewRating.isEmpty)
                {
                    cell.ratingView.value = CGFloat(Int(self.viewModel.reviewRating) ?? Int(0.0))
                    self.viewModel.star_rating = Int(cell.ratingView.value)
                }
                return cell
            }
        }
        else{
           
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewRatingCell.cellIdentifier(), for: indexPath) as! ReviewRatingCell
                cell.selectionStyle = .none
                cell.headerLabel.isHidden = true
                if self.viewModel.review_id != 0 ,!(self.viewModel.reviewRating.isEmpty)
                {
                    cell.ratingView.value = CGFloat(Int(self.viewModel.reviewRating) ?? Int(0.0))
                    self.viewModel.star_rating = Int(cell.ratingView.value)
                }
                return cell
            }
            else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextCell.cellIdentifier(), for: indexPath) as! ReviewTextCell
                cell.selectionStyle = .none
                if self.viewModel.review_id != 0,!(self.viewModel.title.isEmpty)
                {
                   cell.titleTextField.text = self.viewModel.title
                }
                return cell
            }
            else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextAreaCell.cellIdentifier(), for: indexPath) as! ReviewTextAreaCell
                cell.selectionStyle = .none
                if self.viewModel.review_id != 0,!(self.viewModel.detailDescription.isEmpty)
                {
                     cell.detailTextView.text = self.viewModel.detailDescription
                }
               
                cell.detailTextView.addToolBar()
                return cell
            }
            else if let modelObj : ReviewQuestions = model as? ReviewQuestions
            {
                if modelObj.type == ReviewQuestionType.Text.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextCell.cellIdentifier(), for: indexPath) as! ReviewTextCell
                    cell.textQuestion.text = modelObj.question
                    
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    if !(obj?.answer.isEmpty ?? true){
                       cell.titleTextField.text = obj?.answer ?? ""
                    }
                    cell.selectionStyle = .none
                    return cell
                }
                else if modelObj.type == ReviewQuestionType.TextArea.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTextAreaCell.cellIdentifier(), for: indexPath) as! ReviewTextAreaCell
                    cell.textViewQuestion.text = modelObj.question
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    if !(obj?.answer.isEmpty ?? true){
                        cell.detailTextView.text = obj?.answer ?? ""
                    }
                   
                    cell.detailTextView.addToolBar()
                    cell.selectionStyle = .none
                    return cell
                }
                else if modelObj.type == ReviewQuestionType.Select.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewDropDownCell.cellIdentifier(), for: indexPath) as! ReviewDropDownCell
                    cell.questionTxt.text = modelObj.question
                    cell.selectAnswer.isUserInteractionEnabled = false
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    if !(obj?.answer.isEmpty ?? true){
                        cell.selectAnswer.text = obj?.answer ?? ""
                    }
                    cell.selectionStyle = .none
                    return cell
                }
                else if modelObj.type == ReviewQuestionType.Yes_No.rawValue
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewSelectCell.cellIdentifier(), for: indexPath) as! ReviewSelectCell
                    cell.questionTxt.text = modelObj.question
                    cell.selectionStyle = .none
                
                    let obj = self.viewModel.questionAnswer.filter({$0.question_id == modelObj.question_id}).first
                    
                    if !tabButton{
                        if obj?.answer == "Yes"{
                            self.selectedDic = [indexPath.row : 1]
                            
                        }else if obj?.answer == "No"{
                            self.selectedDic = [indexPath.row : 2]
                        }
                    }
                   
                    
                    cell.yesImgView.image = self.selectedDic[indexPath.row] == 1 ? UIImage.init(named: "radio_selected") : UIImage.init(named: "radio_unselected")
                    
                    cell.noImgView.image = self.selectedDic[indexPath.row] == 2 ? UIImage.init(named: "radio_selected") : UIImage.init(named: "radio_unselected")
                    
                    
                    
                    cell.yesButton.touchUp = { button in
                        self.tabButton = true
                        self.selectedDic = [indexPath.row : 1]
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    cell.noButton.touchUp = { button in
                        self.tabButton = true
                        self.selectedDic = [indexPath.row : 2]
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.viewModel.reviewQuestions[indexPath.row]
        if let modelObj : ReviewQuestions = model as? ReviewQuestions{
            if modelObj.type == ReviewQuestionType.Select.rawValue{
                let cell = tableView.cellForRow(at: indexPath)as! ReviewDropDownCell
                self.setupCategoryDropDown(parentView: cell.selectAnswer, options: modelObj.option_values)
                self.categoryDropDown.show()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let model = self.viewModel.reviewQuestions[indexPath.row]
        if let modelObj : ReviewQuestions = model as? ReviewQuestions{
            if modelObj.type == ReviewQuestionType.Select.rawValue{
                self.categoryDropDown.hide()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

        let model = self.viewModel.reviewQuestions[indexPath.row]

        if isFromOrderTracking == true{

            if indexPath.row == 1
            {
                return 204
            }
            else if let modelObj : ReviewQuestions = model as? ReviewQuestions
            {
                if modelObj.type == ReviewQuestionType.TextArea.rawValue
                {
                    return 204
                }
            }
            return 100

        }
        else{
            if indexPath.row == 2 {
                return 204
            }
            else if let modelObj : ReviewQuestions = model as? ReviewQuestions
            {
                if modelObj.type == ReviewQuestionType.TextArea.rawValue
                {
                    return 204
                }
            }
            return 100
        }
    }


    func setupCategoryDropDown(parentView : CustomTextField, options : [String]) {
       
        categoryDropDown.anchorView = parentView
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: parentView.bounds.height)
        categoryDropDown.dataSource.removeAll()
        categoryDropDown.dataSource.append(contentsOf: options)
        categoryDropDown.selectionAction = { [weak self] (index, item) in
            parentView.text = item
            print(item)
        }
    }
}

//MARK:- Tap gesture
extension ReviewViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

