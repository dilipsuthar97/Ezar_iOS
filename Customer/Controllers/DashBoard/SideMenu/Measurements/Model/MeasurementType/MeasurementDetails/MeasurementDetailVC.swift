//
//  MeasurementDetailVC.swift
//  Customer
//
//  Created by webwerks on 4/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MeasurementDetailVC: BaseViewController {

    //MARK:- Reuired Variables
    @IBOutlet weak var tableView: UITableView!
    var viewModel : MeasurementDetailViewModel = MeasurementDetailViewModel()
    var bottomView = ContainerView()
    
    var txtTitleArray = [TITLE.MeasurementName, TITLE.MyHeight, TITLE.MyWeight, TITLE.MyPreferredCollarSizeOptional]
    
    var inputTxtPlaceHolderArray = [TITLE.MyMeasurementAfterLooseWeight, TITLE.SelectHeightCM, TITLE.SelectWeightLBS, TITLE.SelectCollarSize]
    
    var measurementNameTxtField : CustomTextField = CustomTextField()
    var myHeightTxtField : CustomTextField = CustomTextField()
    var myWeightTxtField : CustomTextField = CustomTextField()
    var collarSizeTxtField : CustomTextField = CustomTextField()
    
    var footerView : UIView!
    
    //MARK: - DropDown
    let categoryDropDown = DropDown()
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        categoryDropDown.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        categoryDropDown.customCellConfiguration = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setUpTableUI()
        self.setCustomBottomBar()
        self.getMeasurementOptionsWebService()
        self.categoryDropDown.dismissMode = .onTap
        self.categoryDropDown.direction = .any
       
    }
    
    func getMeasurementOptionsWebService()
    {
        self.viewModel.getMeasurementOptions {
            self.tableView.reloadData()
//            if self.viewModel.measuremetTemplate?.fitOptions.count != 0
//            {
//                if self.viewModel.measurementType != "1"{
//                    self.viewForFooterInTableView()
//                }
//            }
            
//            else{
//                if self.viewModel.measurementType != "1"{
//                    self.viewForFooterInTableView()
//                }
//            }
        }
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.MeasurementDetail.localized
    }
    
    //MARK:- Helpers for Custom Bottom Bar
    func setCustomBottomBar(){
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.LETsGO.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }

    //MARK:- Helper for Table Setup
    func setUpTableUI()
    {
        tableView.register(UINib(nibName: MeasurementDetailCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: MeasurementDetailCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MeasurementDetailVC : ButtonActionDelegate
{
    func onClickBottomButton(button: UIButton) {

        self.insertValueForValidation()
        if measurementNameTxtField.isValid()
         {
            if self.viewModel.measuremetTemplate?.measurement_template_list.count == 0{
                INotifications.show(message: TITLE.customer_measurement_option.localized)
                return
            }
            
            if self.viewModel.measuremetTemplate?.fitOptions.count == 0
            {
                let vc = TakeMeasurementViewController.loadFromNib()
                vc.viewModel.measurementDetailModel = self.viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if self.viewModel.measurementType == "1"{
                    let vc = FittingVC.loadFromNib()
                    vc.viewModel = self.viewModel
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = TakeMeasurementViewController.loadFromNib()
                    vc.viewModel.measurementDetailModel = self.viewModel
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func insertValueForValidation()
    {
        measurementNameTxtField.text = self.viewModel.measurementName
        myHeightTxtField.text = self.viewModel.height
        myWeightTxtField.text = self.viewModel.weight
        collarSizeTxtField.text = self.viewModel.collarSize
    }
}

//MARK:- Table Delegate and DataSource
extension MeasurementDetailVC : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return txtTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementDetailCell.cellIdentifier(), for: indexPath) as! MeasurementDetailCell
        cell.selectionStyle = .none
        cell.txtTitleLabel.text = txtTitleArray[indexPath.row].localized
     
        cell.inputTxtField.placeholder = inputTxtPlaceHolderArray[indexPath.row].localized
        cell.inputTxtField.tag = indexPath.row
        cell.inputTxtField.delegate = self
        self.valueOfCell(cell.inputTxtField)
        return cell
    }
    
    func valueOfCell(_ textField: UITextField) {
        
       // COMMON_SETTING.getTextFieldAligment(textField: textField)
        switch textField.tag
        {
        case 0:
            textField.text = self.viewModel.measurementName
            measurementNameTxtField = textField as! CustomTextField
            measurementNameTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.measurementName.localized, EmptyMessage: MESSAGE.invalidName.localized + TITLE.measurementName.localized))
            break
        case 1:
            textField.text = self.viewModel.height
            myHeightTxtField = textField as! CustomTextField
            
            break
        case 2:
            textField.text = self.viewModel.weight
            myWeightTxtField = textField as! CustomTextField
            break
        case 3:
            collarSizeTxtField = textField as! CustomTextField
            textField.text = self.viewModel.collarSize
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func viewForFooterInTableView()
    {
        if self.footerView == nil
        {
            self.footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-10, height: 90))
            self.tableView.tableFooterView = footerView
            
            let showMoreLabel = UILabel(frame: CGRect(x: 30, y: 0, width: MAINSCREEN.size.width - 60, height: 18))
            showMoreLabel.textColor = Theme.darkGray
            showMoreLabel.text = TITLE.selectType.localized
           showMoreLabel.textAlignment = .left
            showMoreLabel.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 13)
            showMoreLabel.isUserInteractionEnabled = true
            self.footerView.addSubview(showMoreLabel)
            showMoreLabel.semanticContentAttribute = COMMON_SETTING.getRTLOrLTRAligment()
            showMoreLabel.textAlignment = COMMON_SETTING.getRTLOrLTRTextAlignment()
            
            let inputTxtField: CustomTextField = CustomTextField.init(frame: CGRect(x: 40, y: 34, width: UIScreen.main.bounds.size.width - 80, height: 43))
            inputTxtField.cornerRadius = 22
            inputTxtField.textLength = 40
            inputTxtField.textColor = Theme.navBarColor
            inputTxtField.placeHolderColor = Theme.lightGray
            inputTxtField.backgroundColor = Theme.bgColor
            inputTxtField.text = TITLE.superslim.localized
            inputTxtField.endEditing(true)
            inputTxtField.font = UIFont.init(customFont: CustomFont.FuturanM, withSize: 13)
            inputTxtField.RightImage = UIImage.init(named: "downarrow")
            self.setupCategoryDropDown(parentView: inputTxtField)
            COMMON_SETTING.getTextFieldAligment(textField: inputTxtField)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showCategoryList))
            tapGesture.cancelsTouchesInView = false
            tapGesture.delegate = self
            
            inputTxtField.addGestureRecognizer(tapGesture)
            
            self.footerView.addSubview(inputTxtField)
            
        }
    }
    
    @objc func showCategoryList() {
        self.categoryDropDown.show()
    }
    
    func setupCategoryDropDown(parentView : CustomTextField) {
        categoryDropDown.anchorView = parentView
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: parentView.bounds.height)
        
        
        for options in self.viewModel.measuremetTemplate?.fitOptions ?? []
        {
            categoryDropDown.dataSource.append(options.show_label)
        }
        
//        categoryDropDown.dataSource.append(TITLE.superslim.localized)
//        categoryDropDown.dataSource.append(TITLE.slim.localized)
//        categoryDropDown.dataSource.append(TITLE.comfort.localized)
//        categoryDropDown.dataSource.append(TITLE.Loose.localized)

        categoryDropDown.selectionAction = { [weak self] (index, item) in
            parentView.text = item
            self?.viewModel.selected_type = item
        }
    }
}

//MARK:- Tap gesture
extension MeasurementDetailVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

//MARK:- UITextView Delegate Methods
extension MeasurementDetailVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag
        {
        case 0:
            textField.addToolBar()
           // textField.keyboardType = .asciiCapable
            textField.returnKeyType = .next
            break
        case 1:
            textField.addToolBar()
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .next
            break
        case 2:
            textField.addToolBar()
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .next
            break
        case 3:
            textField.addToolBar()
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .done
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag
        {
        case 0:
            self.viewModel.measurementName = textField.text ?? ""
            break
        case 1:
            self.viewModel.height = textField.text ?? ""
            break
        case 2:
            self.viewModel.weight = textField.text ?? ""
            break
        case 3:
            self.viewModel.collarSize = textField.text ?? ""
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        performAction(textField)
        return true
    }
    
    func performAction(_ textField: UITextField) {
        //action events
        let value = textField.tag + 1
        switch value
        {
        case 1:
            myHeightTxtField.becomeFirstResponder()
            break
        case 2:
            myWeightTxtField.becomeFirstResponder()
            break
        case 3:
            collarSizeTxtField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 0
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.count <= 250
        }
        else if textField.tag == 1
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.count <= 6
        }
        else if textField.tag == 2
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.count <= 3
        }
        else if textField.tag == 3
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.count <= 3
        }
        return true
    }
}
