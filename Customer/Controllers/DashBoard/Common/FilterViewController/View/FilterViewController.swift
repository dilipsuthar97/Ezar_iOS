//
//  FilterViewController.swift
//  Customer
//
//  Created by webwerks on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import NHRangeSlider

protocol FilterViewControllerDelegate : class {
    func getSelectedValue(applyFilterArray : [NSMutableDictionary])
    
}

class FilterViewController: BaseViewController {
    
    //MARK:- Variable declaration
    var viewModel : FilterViewModel = FilterViewModel()
    @IBOutlet weak var filtersTblView: UITableView!
    @IBOutlet weak var subfiltersTblView: UITableView!
    var filters = [Filters]()
    var subFilters = [SubFilter]()
    var currentFilterIndex = 0
    var filterName = ""
    var filterCode = ""
    var applyFilterArray : [NSMutableDictionary] = []
    var bottomView = ContainerView()
    var minValue : Double = 0.00
    var maxValue : Double = 0.00
    weak var delegate: FilterViewControllerDelegate?

    struct Filters {
        
        var filterName : String?
        var code : String?
        var type : String?
        var is_applied : Int?
        var subFilters = [SubFilter]()
        
        init(jsonData : anyDict) {
            
            self.filterName = jsonData["filterName"] as? String ?? ""
            self.code = jsonData["code"] as? String ?? ""
            self.type = jsonData["type"] as? String ?? ""
            self.is_applied = jsonData["is_applied"] as? Int ?? -1
            let subFilters = jsonData["subFilters"] as! [anyDict]
            for subFilter in subFilters {
                self.subFilters.append(SubFilter(jsonData:subFilter))
            }
        }
    }
    
    struct SubFilter {
        
        //var isSelected = false
        var subFilterName : String?
        var description   : String?
        var option_id     : String?
        var count         : Int?
        var color_code    : String?
        var image         : String?
        var is_applied    : Int?
        
        init(jsonData : anyDict) {
            //self.isSelected = jsonData["isSelected"] as? Bool ?? false
            self.subFilterName = jsonData["subFilterName"] as? String ?? ""
            self.description = jsonData["description"] as? String ?? ""
            self.option_id = jsonData["option_id"] as? String ?? ""
            self.count = jsonData["count"] as? Int ?? 0
            self.color_code = jsonData["color_code"] as? String ?? ""
            self.image = jsonData["image"] as? String ?? ""
            self.is_applied = jsonData["is_applied"] as? Int ?? -1
        }
        
    }

    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setTheFilterArray(filterArray: [ProductFilter])
    {
        for filters in filterArray
        {
            if filters.options.count > 0
            {
                self.viewModel.filterArray.append(filters)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
        setCustomBottomBar()
        setupTableView()
    }
    
    
    //MARK:- Helpers for Custom Bottom Bar
    func setCustomBottomBar(){
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.customer_apply.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    //MARK:- Helpers for data & UI
    func setupUI() {
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.Filters.localized
        setRightBarButton(title: TITLE.ClearAll)
        
        for model in self.viewModel.filterArray {
            var mainFilter = anyDict()
            mainFilter["filterName"] = model.label
            mainFilter["code"] = model.code
            mainFilter["type"] = model.type
            mainFilter["is_applied"] = model.is_applied
            var subFiltersArray = [anyDict]()
            for options  in model.options
            {
                let option_id = options.iOption_id == 0 ? options.option_id : "\(options.iOption_id)"
                let tempDict : anyDict = ["subFilterName":options.display,
                                          "isSelected": options.is_applied,
                                          "description":options.description,
                                          "option_id":option_id,
                                          "count":options.count,
                                          "color_code":options.color_code,
                                          "image":options.image,
                                          "is_applied":options.is_applied]
                subFiltersArray.append(tempDict)
                if options.is_applied == 1
                {
                    let dictionary : NSMutableDictionary = [:]
                    dictionary.addEntries(from: [model.code:option_id])
                    addToApplyFilterArray(dictionary: dictionary, key: model.code)
                }
            }
            mainFilter["subFilters"] = subFiltersArray
            filters.append(Filters(jsonData: mainFilter))
        }
    }
    
    override func onClickLeftButton(button: UIButton) {
        if self.viewModel.filterSortClassType == .PRODUCTSVC{
            self.dismiss(animated: true, completion: nil)

        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupTableView() {
        
        filtersTblView.register(UINib(nibName: FilterTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: FilterTableViewCell.cellIdentifier())
        subfiltersTblView.register(UINib(nibName: SortTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SortTableCell.cellIdentifier())
        subfiltersTblView.register(UINib(nibName: FilterColorTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: FilterColorTableCell.cellIdentifier())
        subfiltersTblView.register(UINib(nibName: PriceRangeTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: PriceRangeTableViewCell.cellIdentifier())
        
        let indexPath = IndexPath(row: 0, section: 0)
        if self.filters.count > 0
        {
            filtersTblView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            filtersTblView.delegate?.tableView!(filtersTblView, didSelectRowAt: indexPath)
        }
        
        filtersTblView.backgroundColor =  UIColor.lightGray//(named: "BorderColor")! //UIColor.init(patternImage: UIImage.init(named: "Nav_BG")!)
        filtersTblView.tableFooterView = UIView()
        subfiltersTblView.tableFooterView = UIView()  
    }
    
    override func onClickRightButton(button: UIButton) {
        //self.navigateToParentController(applyFilterArray: [])
        if self.viewModel.filterSortClassType == .PRODUCTSVC{
           
            delegate?.getSelectedValue(applyFilterArray: [])
             self.navigationController?.popViewController(animated: true)
        }else{
            self.navigateToParentController(applyFilterArray: [])
        }
    }
}

//MARK:- TableView datasoruce & delegate methods

extension FilterViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return filters.count
        }
        else{
            return self.filterName.uppercased().contains("PRICE") ? self.getMinMaxPriceRange() : self.subFilters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
            
            let filter = filters[indexPath.row]
            cell.titleLbl.text = filter.filterName

            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            return cell
        }
        else {
            
            let subFilter = subFilters[indexPath.row]
            if (self.filterName.uppercased().contains("COLOR") || self.filterName.uppercased().contains("FABRIC"))
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterColorTableCell", for: indexPath) as! FilterColorTableCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
                cell.titleLabel.text = subFilter.subFilterName
                let rgbValue = (subFilter.color_code?.replacingOccurrences(of: "#", with: "0x"))
                let rgbImage : String = subFilter.image ?? ""
                if !((rgbValue?.isEmpty) ?? false)
                {
                    cell.colorView.image = UIImage.init(color: UIColor(hex: rgbValue ?? "0x000000"))
                }
                else
                {
                    let imageUrlString = URL.init(string: rgbImage)
                    cell.colorView?.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                if subFilter.is_applied == 1 {
                    cell.selectedView.isHidden = false
                    //cell.contentView.backgroundColor = UIColor.gray
                } else{
                    cell.selectedView.isHidden = true
                   //cell.contentView.backgroundColor = UIColor.clear
                }
                return cell
            }
            else if self.filterName.uppercased().contains("PRICE")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: PriceRangeTableViewCell.cellIdentifier(), for: indexPath) as! PriceRangeTableViewCell
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
                cell.isSelected = false
                removeSubViews(pView: cell.rangeView)
                let sliderCustomStringView = NHRangeSliderView(frame: CGRect(x: 5, y: 0, width: cell.rangeView.frame.size.width - 10, height: 30) )
                sliderCustomStringView.trackHighlightTintColor = UIColor(named: "BorderColor")! //UIColor.black
                sliderCustomStringView.stepValue = 1
                sliderCustomStringView.gapBetweenThumbs = 10
                sliderCustomStringView.thumbSize = 16
                sliderCustomStringView.thumbTintColor = UIColor(named: "BorderColor")! //UIColor.black
                sliderCustomStringView.thumbLabelStyle = .FOLLOW
                sliderCustomStringView.lowerDisplayStringFormat = "SAR: %.2f"
                sliderCustomStringView.upperDisplayStringFormat = "SAR: %.2f"
                minValue = maxValue == minValue ? 0 : minValue
                maxValue = maxValue == minValue ? 1 : maxValue
                sliderCustomStringView.rangeSlider?.maximumValue = maxValue
                sliderCustomStringView.rangeSlider?.minimumValue = minValue
                sliderCustomStringView.rangeSlider?.upperValue = maxValue
                sliderCustomStringView.rangeSlider?.lowerValue = minValue
                sliderCustomStringView.maximumValue = maxValue
                sliderCustomStringView.minimumValue = minValue
                sliderCustomStringView.upperValue = maxValue
                sliderCustomStringView.lowerValue = minValue
                sliderCustomStringView.delegate = self
                
                sliderCustomStringView.sizeToFit()
                cell.rangeView.addSubview(sliderCustomStringView)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortTableCell", for: indexPath) as! SortTableCell
            
            cell.titleLabel.text = subFilter.subFilterName
            cell.stateButton.tag = indexPath.row

            if subFilter.is_applied == 1 {
                cell.stateButton.setImage(UIImage(named :"selectedicon"), for: .normal)
            } else{
                cell.stateButton.setImage(UIImage(named:"unselected_icon"), for: .normal)
            }
            
            cell.stateButton.touchUp = { button in
                
                for index in 0..<self.subFilters.count
                {
                    let dictionary : NSMutableDictionary = [:]
                    if indexPath.row == index
                    {
                        if self.subFilters[index].is_applied == 1 {
                            self.subFilters[index].is_applied = 0
                            dictionary.addEntries(from: [self.filterCode:self.subFilters[index].option_id ?? ""])
                        } else {
                            self.subFilters[index].is_applied = 1
                            dictionary.addEntries(from: [self.filterCode:self.subFilters[index].option_id ?? ""])
                        }
                        self.addToApplyFilterArray(dictionary: dictionary, key: self.filterCode)
                    }
                    else
                    {
                        self.subFilters[index].is_applied = 0
                    }
                }
                self.filters[self.currentFilterIndex].subFilters = self.subFilters
                self.subfiltersTblView.reloadData()
            }
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func removeSubViews(pView : UIView)
    {
        for subView in pView.subviews
        {
            subView.removeFromSuperview()
        }
    }
    
    func getMinMaxPriceRange() -> Int
    {
        for i in 0..<subFilters.count
        {
            let subFilter = subFilters[i]
            let optionIdValue : Double = Double(subFilter.option_id ?? "0.00") ?? 0.00
            if i == 0
            {
                self.minValue = optionIdValue
            }
            else
            {
                self.maxValue = optionIdValue
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            let selectedCell:FilterTableViewCell = tableView.cellForRow(at: indexPath)! as! FilterTableViewCell
            selectedCell.titleLbl.textColor =  Theme.blackColor
            
            let view = UIView()
            view.backgroundColor = UIColor.white
            selectedCell.selectedBackgroundView = view
            subFilters = filters[indexPath.row].subFilters
            self.filterName = filters[indexPath.row].filterName ?? ""
            self.filterCode = filters[indexPath.row].code ?? ""
            currentFilterIndex = indexPath.row
            self.subfiltersTblView.reloadData()
        }
        else
        {
            if !(self.filterName.uppercased().contains("PRICE"))
            {
                for index in 0..<self.subFilters.count
                {
                    if indexPath.row == index
                    {
                        let dictionary : NSMutableDictionary = [:]
                        if self.subFilters[index].is_applied == 1 {
                            self.subFilters[index].is_applied = 0
                            dictionary.addEntries(from: [self.filterCode:self.subFilters[index].option_id ?? ""])
                        } else {
                            self.subFilters[index].is_applied = 1
                            dictionary.addEntries(from: [self.filterCode:self.subFilters[index].option_id ?? ""])
                        }
                        addToApplyFilterArray(dictionary: dictionary, key: self.filterCode)
                    }
                    else
                    {
                        self.subFilters[index].is_applied = 0
                    }
                }
                self.filters[self.currentFilterIndex].subFilters = self.subFilters
                self.subfiltersTblView.reloadData()
            }
        }
    }
    
    func addToApplyFilterArray(dictionary : NSMutableDictionary, key : String)
    {
        for (index, dic) in self.applyFilterArray.enumerated()
        {
            if dic[key] != nil
            {
                self.applyFilterArray.remove(at: index)
            }
        }
        self.applyFilterArray.append(dictionary)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {

            let selectedCell:FilterTableViewCell = tableView.cellForRow(at: indexPath)! as! FilterTableViewCell
            selectedCell.titleLbl.textColor = UIColor.white
            let view = UIView()
            view.backgroundColor = UIColor.clear
            selectedCell.selectedBackgroundView = view
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 70
        } else {
            return self.filterName.uppercased().contains("PRICE") ? 84 : 50
        }
    }
}

extension FilterViewController : ButtonActionDelegate, NHRangeSliderViewDelegate
{
    func onClickBottomButton(button: UIButton) {
        
        if self.viewModel.filterSortClassType == .PRODUCTSVC{
            if self.applyFilterArray.count > 0
            {
               // self.navigateToParentController(applyFilterArray: self.applyFilterArray)
                delegate?.getSelectedValue(applyFilterArray: self.applyFilterArray)
               // self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            }
            else
            {
                INotifications.show(message: TITLE.customer_option_selection.localized)
            }
        }else{
            if self.applyFilterArray.count > 0
            {
                self.navigateToParentController(applyFilterArray: self.applyFilterArray)
            }
            else
            {
                INotifications.show(message: TITLE.customer_option_selection.localized)
            }
        }
    }
    
    func navigateToParentController(applyFilterArray : [NSMutableDictionary])
    {
        switch self.viewModel.filterSortClassType
        {
        case .CHOOSEFABRICVC:
            let vc = COMMON_SETTING.popToAnyController(type: ChooseFabricVC.self, fromController: self)
            vc.viewModel.applyFilterArray = applyFilterArray
            vc.isSortFilterApply = false
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .PRODUCTSVC:
            let vc = COMMON_SETTING.popToAnyController(type: ProductsVC.self, fromController: self)
            vc.viewModel.applyFilterArray = applyFilterArray
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .NEARESTDELEGATEVC:
            let vc = COMMON_SETTING.popToAnyController(type: NearestDelegateVC.self, fromController: self)
            vc.viewModel.applyFilterArray = applyFilterArray
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .CUFFSTYLEVC:
            let vc = COMMON_SETTING.popToAnyController(type: CuffStyleVC.self, fromController: self)
            self.navigationController?.popToViewController(vc, animated: true)
            break
        case .MANUFACTURESARCHLISTVC:
            let vc = COMMON_SETTING.popToAnyController(type: ManufacturerListVC.self, fromController: self)
            
            vc.searchViewModel?.applyFilterArray = applyFilterArray
            vc.isSortFilterApply = true
            self.navigationController?.popToViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    func sliderValueChanged(slider: NHRangeSlider?) {
        let priceRange = String(format: "%.f-%.f",(slider?.lowerValue) ?? 0.0, (slider?.upperValue) ?? 0.0)
        let dictionary : NSMutableDictionary = [:]
        dictionary.addEntries(from: [self.filterCode:"\(priceRange)"])
        for dictionary in applyFilterArray
        {
            if dictionary["custom_tier_price"] != nil, let index = self.applyFilterArray.index(of: dictionary)
            {
                self.applyFilterArray.remove(at: index)
                break
            }
        }
        self.applyFilterArray.append(dictionary)
    }
}

