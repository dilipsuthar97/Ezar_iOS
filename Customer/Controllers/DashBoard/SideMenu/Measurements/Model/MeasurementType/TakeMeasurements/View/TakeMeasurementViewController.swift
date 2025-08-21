//
//  LoginViewController.swift
//  Thoab
//
//  Created by webwerks on 05/01/18.
//  Copyright © 2018 Thoab. All rights reserved.
//

import UIKit
import STPopup
import IQKeyboardManagerSwift

class TakeMeasurementViewController: BaseViewController, ButtonActionDelegate{
    
    //MARK:- Variables declaration
    @IBOutlet weak var sizeTxt: CustomTextField!
    @IBOutlet weak var sizeTxtDropDown: CustomTextField!
    @IBOutlet weak var collection_View: UICollectionView!
    @IBOutlet weak var playButton: ActionButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var templateTitle: UILabel!
    @IBOutlet weak var templateDescription: UILabel!
    @IBOutlet weak var tableViewImages: UITableView!
    @IBOutlet weak var tableViewImagesHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFieldHeight: NSLayoutConstraint!
    
    var selectedPage : Int = 0
    
    let viewModel :TakeMeasurementViewModel = TakeMeasurementViewModel()
    var bottomView = ContainerView()
    var imageUrl : String = ""
    var selectedImages : String = ""
    
    var minRange : Double = 0.0
    var maxRange : Double = 0.0
    
    //MARK: - DropDown
    let categoryDropDown = DropDown()
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        categoryDropDown.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        categoryDropDown.customCellConfiguration = nil
    }
    
    //MARK :-View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidations()
        registerNib()
        setupTableView()
        CustomBottonBar()
        setTheNewValues()
        IQKeyboardManager.shared.enable = true
        self.categoryDropDown.dismissMode = .onTap
        self.categoryDropDown.direction = .any
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configUI()
        setupNavigation()
        setRightSearchButton()
        sizeTxt.addToolBar()
        sizeTxtDropDown.delegate = self
         COMMON_SETTING.getTextFieldAligment(textField: sizeTxtDropDown)
        
    }
    
    func setupNavigation() {
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.TakeMeasurement.localized
    }
    
    //MARK:- Helpher method
    func customDropDown(){
        setupCategoryDropDown(parentView: sizeTxtDropDown)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showCategoryList))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        sizeTxtDropDown.addGestureRecognizer(tapGesture)
        
    }
    func setupTableView() {
        
        tableViewImages.register(UINib(nibName: StyleInfoTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: StyleInfoTableViewCell.cellIdentifier())
        tableViewImages.separatorStyle = .none
        tableViewImages.layoutIfNeeded()
        tableViewImages.estimatedRowHeight = 260
        tableViewImages.rowHeight = UITableView.automaticDimension
    }
    
    func setupCategoryDropDown(parentView : CustomTextField) {
        categoryDropDown.anchorView = parentView
         
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: parentView.bounds.height)
        
        if categoryDropDown.dataSource.count > 0
        {
            categoryDropDown.dataSource.removeAll()
        }
        if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
            for model in optionaType.dropdown_option  ?? []
            {
                categoryDropDown.dataSource.append(model.title)
            }
        }
        
        categoryDropDown.selectionAction = { [weak self] (index, item) in
            
            parentView.text = item
            self?.sizeTxtDropDown.text = item
            self?.viewModel.dropDownTxt = item
        }
        
    }
    
    @objc func showCategoryList() {
        self.categoryDropDown.show()
    }
    
    override func onClickLeftButton(button: UIButton) {
        if selectedPage == 0
        {
            self.navigationController?.popViewController(animated: true)
        }
        else{
            selectedPage = selectedPage > 0 ? selectedPage - 1 : 0
            self.viewModel.measurements.removeLastObject()
            setTheNewValues()
    
            if let list = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list, list.count > 0{
                let measurementTamplate = list[selectedPage]
                if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
                    if optionaType.option_type == MeasurementSelection.Text.rawValue || optionaType.option_type ==  MeasurementSelection.blank.rawValue {
                        
                        let value = forTrailingZero(temp: measurementTamplate.enterText)
                        
                        self.sizeTxt.text = String(value)
                        
                    }else if optionaType.option_type == MeasurementSelection.Dropdown.rawValue{
                        self.sizeTxtDropDown.text = self.viewModel.dropDownTxt
                        
                    }else{
                    
                        
                    }
                }
            }
            
        }
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }

    
    func CustomBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.NEXT.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.bottomView.backgroundColor = UIColor.white
        self.view.addSubview(self.bottomView)
    }
    
    // MARK: - IBAction Mathod
    func onClickBottomButton(button: UIButton) {
        
        if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
            if optionaType.option_type == MeasurementSelection.Text.rawValue || optionaType.option_type ==  MeasurementSelection.blank.rawValue {
            
                if sizeTxt.isValid(){
                    self.checkForNextView()
                }
                
            }else if optionaType.option_type == MeasurementSelection.Dropdown.rawValue{
            
                //if sizeTxtDropDown.isValid(){
                    self.saveMeasurementValue()
               // }
            }
        }
    }
    
    func checkForNextView()
    {
        var sizeValue : Double = Double(sizeTxt.text ?? "0") ?? 0.0
        
        if LocalDataManager.getSelectedLanguage() != LanguageSelection.ENGLISH.rawValue
        {
            sizeValue = Double(sizeTxt.text?.replacedArabicDigitsWithEnglish ?? "0") ?? 0.0
        }
        
        
        if let measurementTemplate = self.viewModel.measurementDetailModel?.measuremetTemplate{
            for(_, _) in (measurementTemplate.measurement_template_list.enumerated()){
                measurementTemplate.measurement_template_list[selectedPage].enterText = sizeValue
            }
            
            if sizeValue <= 0{
                INotifications.show(message: TITLE.customer_measurement_no_zero.localized)
                return
            }
            
            //measurement dependancy
            if measurementTemplate.measurement_template_list[selectedPage].option_id_depend_on != 0{
                
                if measurementTemplate.measurement_template_list.count > 0{
                    for i in measurementTemplate.measurement_template_list {
                        
                        if ((String(measurementTemplate.measurement_template_list[selectedPage].option_id_depend_on) == i.measurement_option_id) && (i.option_type == "" || i.option_type == "1")) {
                            
                            let selectedMeasurement = measurementTemplate.measurement_template_list[selectedPage]
                            minRange = 0.0
                            maxRange = 0.0
                            
                            if selectedMeasurement.min_operator.isEmpty{
                                minRange = Double(selectedMeasurement.min_value) ?? 0.0
                            }
                            
                            if selectedMeasurement.max_operator.isEmpty{
                                maxRange = Double(selectedMeasurement.max_value) ?? 0.0
                            }
                            
                            if !selectedMeasurement.min_operator.isEmpty && !selectedMeasurement.min_value.isEmpty{
                                minRange = getCalculatedValue(mOperator: selectedMeasurement.min_operator, size: String(i.enterText), minMaxValue: selectedMeasurement.min_value)                           }
                            
                            if !selectedMeasurement.max_operator.isEmpty && !selectedMeasurement.max_value.isEmpty{
                                maxRange = getCalculatedValue(mOperator: selectedMeasurement.max_operator, size: String(i.enterText), minMaxValue: selectedMeasurement.max_value)
                            }
                        }
                    }
                }
            }else{
                minRange = Double(measurementTemplate.measurement_template_list[selectedPage].min_value) ?? 0.0
                maxRange = Double(measurementTemplate.measurement_template_list[selectedPage].max_value) ?? 0.0
            }
            
            if minRange != 0.0 && maxRange != 0.0{
                if (Double(sizeValue) > maxRange || Double(sizeValue) < minRange){
                    self.showValidationPopup(message: "\(TITLE.customer_minValMsg.localized) \(minRange.truncateDouble(places: 2)) \(TITLE.customer_and.localized) \(maxRange.truncateDouble(places: 2)) \(TITLE.customer_maxValMsg.localized) ")
                }else{
                    self.saveMeasurementValue()
                }
            }else if minRange != 0.0{
                
                if (Double(sizeValue) < minRange){
                    self.showValidationPopup(message: "\(TITLE.onlyMinValue.localized) \(minRange.truncateDouble(places: 2))")
                }else{
                    self.saveMeasurementValue()
                }
            }else if maxRange != 0.0{
                
                if (Double(sizeValue) > maxRange){
                    
                    self.showValidationPopup(message: "\(TITLE.onlyMaxValueAlert.localized) \(maxRange.truncateDouble(places: 2))")
                }else{
                    self.saveMeasurementValue()
                }
            }
            else{
                self.saveMeasurementValue()
            }
        }
    }
    
    
    func showValidationPopup(message : String) {
        let alert = UIAlertController(title: "\(TITLE.customer_warning.localized + "!!")", message: message, preferredStyle: .alert)
        
        let yesActtion = UIAlertAction(title: TITLE.yes.localized, style: .default) { (alert) in
            self.saveMeasurementValue()
        }
        let cancelAction = UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alert.addAction(yesActtion)
        alert.addAction(cancelAction)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func saveMeasurementValue(){
        
        if selectedPage == (((self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list.count)!) - 1)
        {
            insertMeasurementvalues()
            let profile = Profile.loadProfile()
            self.viewModel.customer_id = profile?.id ?? 0
            self.viewModel.saveMeasurement {
                
                self.viewModel.updateMeasurementForCartProduct {
                    IQKeyboardManager.shared.enable = false
                    IQKeyboardManager.shared.enableAutoToolbar = false
                    let vc = COMMON_SETTING.popToAnyController(type: ShoppingBagVC.self, fromController: self)
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        else
        {
            if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
                if optionaType.option_type == MeasurementSelection.Text.rawValue || optionaType.option_type ==  MeasurementSelection.blank.rawValue {
                    
                    var sizeValue : Double = Double(sizeTxt.text ?? "0") ?? 0.0
                    
                    if LocalDataManager.getSelectedLanguage() != LanguageSelection.ENGLISH.rawValue
                    {
                        sizeValue = Double(sizeTxt.text?.replacedArabicDigitsWithEnglish ?? "0") ?? 0.0
                    }
                    
                    if sizeValue <= 0
                    {
                        INotifications.show(message: TITLE.customer_measurement_no_zero.localized)
                        return
                    }
                    
                }
            }
           
            insertMeasurementvalues()
            selectedPage = selectedPage + 1
            setTheNewValues()
        }
    }
    
    func getCalculatedValue(mOperator:String,size:String,minMaxValue:String) -> Double {
        switch mOperator {
        case "+":
            return (Double(size) ?? 0.0) + (minMaxValue.toDouble)
        case "-":
            return (Double(size) ?? 0.0) - (minMaxValue.toDouble)
        case "*":
            return (Double(size) ?? 0.0) * (minMaxValue.toDouble)
        case "/":
            return (Double(size) ?? 0.0) / (minMaxValue.toDouble)
            
        default:
            return 0.0
        }
    }
    
    func setTheNewValues()
    {
        if let list = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list, list.count > 0{
            
            let measurementTamplate = list[selectedPage]
            
            
            templateTitle.text = measurementTamplate.title
            templateDescription.text = measurementTamplate.description
            imageUrl = measurementTamplate.image.count != 0 ? measurementTamplate.image[0] : ""
            let videoLink = measurementTamplate.video_link
            playButton.isHidden = videoLink.isEmpty
            pageControl.numberOfPages = list[selectedPage].image.count
            pageControl.currentPage = 0
            
            
            playButton.touchUp = { button in
                let vc = VideoPlayerVC.loadFromNib()
                
                vc.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 400)
                vc.navTitle = measurementTamplate.title
                vc.videoString = videoLink
                
                let popupController = STPopupController.init(rootViewController: vc)
                popupController.transitionStyle = .fade
                popupController.containerView.backgroundColor = UIColor.clear
                popupController.backgroundView?.backgroundColor = UIColor.black
                popupController.backgroundView?.alpha = 0.7
                popupController.hidesCloseButton = false
                popupController.navigationBarHidden = true
                popupController.present(in: self, completion: {
                    let lButton = ActionButton(type: .custom)
                    lButton.setupAction()
                    lButton.backgroundColor = UIColor.clear
                    lButton.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.size.width, height: MAINSCREEN.size.height)
                    lButton.touchUp = { button in
                        popupController.dismiss()
                    }
                    popupController.backgroundView?.addSubview(lButton)
                })
            }
            if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
                if optionaType.option_type == MeasurementSelection.Text.rawValue  || optionaType.option_type ==  MeasurementSelection.blank.rawValue {
                    sizeTxt.text = ""
                    sizeTxt.isHidden = false
                    sizeTxtDropDown.isHidden = true
                    tableViewImages.isHidden = true
                    bottomView.isHidden = false
                    txtFieldHeight.constant = 48
                    tableViewImagesHeight.constant = 0
                    
                }else if (optionaType.option_type == MeasurementSelection.Dropdown.rawValue){
                    
                    sizeTxtDropDown.text = ""
                    if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
                        if optionaType.dropdown_option?.count ?? 0 > 0{
                            if self.sizeTxtDropDown.text == ""{
                                self.sizeTxtDropDown.text = optionaType.dropdown_option?[0].title
                            }
                        }
                    }
                    
                    sizeTxt.isHidden = true
                    sizeTxtDropDown.isHidden = false
                    tableViewImages.isHidden = true
                    bottomView.isHidden = false
                    txtFieldHeight.constant = 48
                    tableViewImagesHeight.constant = 0
                    
                    self.customDropDown()
                }else{
                    txtFieldHeight.constant = 0
                    self.selectedImages = ""
                    if let option =
                        self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option{
                        if option.count > 0{
                            tableViewImagesHeight.constant = CGFloat(260 * option.count + 50)
                        }
                    }
                    
                    sizeTxt.isHidden = true
                    sizeTxtDropDown.isHidden = true
                    tableViewImages.isHidden = false
                    bottomView.isHidden = true
                    
                    tableViewImages.reloadData()
                   
                }
            }
            
             collection_View.reloadData()
            
        }
    }
    
    func insertMeasurementvalues()
    {
        if let list = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list, list.count > 0{
            let measurementTamplate = list[selectedPage]
            
            if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
                if optionaType.option_type == MeasurementSelection.Text.rawValue || optionaType.option_type ==  MeasurementSelection.blank.rawValue{
                    let detail : NSMutableDictionary = NSMutableDictionary()
                    detail.addEntries(from: ["option_id": measurementTamplate.measurement_option_id,"size": sizeTxt.text ?? "0", "title":measurementTamplate.title])
                    self.viewModel.measurements.add(detail)
                    
                }else if optionaType.option_type == MeasurementSelection.Dropdown.rawValue{
                    let detail : NSMutableDictionary = NSMutableDictionary()
                    detail.addEntries(from: ["option_id": measurementTamplate.measurement_option_id,"size": sizeTxtDropDown.text ?? "0", "title":measurementTamplate.title])
                    self.viewModel.measurements.add(detail)
                    
                }else{
                    let detail : NSMutableDictionary = NSMutableDictionary()
                    detail.addEntries(from: ["option_id": measurementTamplate.measurement_option_id,"size": self.selectedImages , "title":measurementTamplate.title])
                    self.viewModel.measurements.add(detail)
                }
            }
        }
    }
    
    func configUI() {
        self.sizeTxt.placeholder = TITLE.enter_size.localized
        pageControl.numberOfPages = (self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image.count) ?? 0
        pageControl.currentPage = 0
        playButton.setImage(UIImage(named : "play_Icon")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        
    }
    
    func setupValidations() {
        
        sizeTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.size.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.size.localized))

    }
    
    func registerNib() {
        self.collection_View.register(UINib(nibName:MeasurementCollectionViewCell.cellIdentifier(),bundle:nil), forCellWithReuseIdentifier: MeasurementCollectionViewCell.cellIdentifier())
    }
    
    
    @IBAction func pageControlChanged(page:UIPageControl)  {
        
        let width = self.collection_View.frame.size.width
        let scrollTo = CGPoint.init(x: width * CGFloat(pageControl.currentPage), y: 0)
        self.collection_View.setContentOffset(scrollTo, animated: true)
    }
}

//MARK:- TextFieldDelegte Methods
extension TakeMeasurementViewController :UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let optionaType = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage]{
            if optionaType.option_type == MeasurementSelection.Text.rawValue || optionaType.option_type ==  MeasurementSelection.blank.rawValue{
                let text = selectedPage == ((self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list.count)! - 1) ? TITLE.done.localized : TITLE.NEXT.localized
                sizeTxt.addToolBarWithButton(title: text).touchUp = { button in
                    textField.resignFirstResponder()
                    self.checkForNextView()
                    
                }
            }
            return true
        }else{
            return false
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.nextField == nil) {
            textField.resignFirstResponder()
        } else {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //self.checkForNextView()
    }
}



// MARK: - UICollectionView Delegate
extension TakeMeasurementViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image.count) ?? 1
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeasurementCollectionViewCell.cellIdentifier(), for: indexPath as IndexPath) as! MeasurementCollectionViewCell
        let imageString = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image[indexPath.row]
        let imageUrlString = URL.init(string: imageString ?? "")
        cell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(collection_View.contentOffset.x) / Int(collection_View.frame.width)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Delegate
extension TakeMeasurementViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collection_View.frame.size.width, height: self.collection_View.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0, bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

//MARK:- Extension for Double Decimal
extension Double
{
    func truncateDouble(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
}

//MARK:- Tap gesture
extension TakeMeasurementViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
//MARK:- TableView datasoruce & delegate methods

extension TakeMeasurementViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let option = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option{
            return option.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StyleInfoTableViewCell.cellIdentifier(), for: indexPath) as! StyleInfoTableViewCell
        
        if let imageUrl = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option?[indexPath.row]{
            
            cell.nameTxtLbl.text = imageUrl.title
            
            let imageUrlString = imageUrl.path
            let encodedLink = imageUrlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let encodedURL = NSURL(string: encodedLink!)! as URL
            
            cell.styleImageView.sd_setImage(with: encodedURL, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
            
        }
        
        cell.selectedView.isHidden = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option?[indexPath.row].isChecked == true ? false : true
        
        cell.selectionStyle = .default
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let imageUrl = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option?[indexPath.row].path{
            
            self.selectedImages = imageUrl
        }
        
        if let measurement = self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option{

            for i in measurement{
                i.isChecked = false
            }
        }
 self.viewModel.measurementDetailModel?.measuremetTemplate?.measurement_template_list[selectedPage].image_option?[indexPath.row].isChecked = true
        
     self.saveMeasurementValue()
    }
}

