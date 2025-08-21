//
//  CuffStyleVC.swift
//  Customer
//
//  Created by webwerks on 15/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class CuffStyleVC: BaseViewController, ButtonActionDelegate {
    func onClickBottomButton(button: UIButton) {
        print("Test Button")
    }
    
    
    //MARK: - Variable declaration
    var viewModel : CuffStyleViewModel = CuffStyleViewModel()
    var selectedIndex : Int = 1
    var selectedModelList : [ProductOptionValues] = []
    var option_id : String = ""
    var controller :  SellerDetailVC? = nil
    var optionIdArray : [String] = []
    var listOptions    : [ProductOption] = [ProductOption]()
    var productOptionIndex : Int = 0
    var productOptionsArray : [ProductOption] = [ProductOption]()
    var currentProductOtpionArray : [ProductOption] = [ProductOption]()
    var productOptionsArrayContainer : [[ProductOption]] = [[ProductOption]]()
    
    @IBOutlet weak var cuffStyleTblView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonHeightConstraint: NSLayoutConstraint! {
        didSet{
            nextButtonHeightConstraint.constant = 0
        }
    }
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        option_id = optionIdArray.count != 0 ? optionIdArray[selectedIndex] : ""
        navigationItem.title = TITLE.Style.localized
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigation()
        webServiceCallForProductOptions()
    }
            
    private func setUpNavigation() {
        navigationItem.title = TITLE.tailor_your_dress.localized
        setNavigationBarHidden(hide: false)
        setBackButton()
    }
    
    override func onClickLeftButton(button: UIButton) {
        nextButtonHeightConstraint.constant = 0
        if productOptionIndex == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            productOptionIndex = productOptionIndex - 1
            navigationItem.title = self.getHeaderTitle()
            cuffStyleTblView.reloadData()
        }
    }
    
    override func onClickRightButton(button: UIButton) {
        if button.tag == 0 {
        } else if button.tag == 1 {
            let vc = SortViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            vc.filterSortClassType = .CUFFSTYLEVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if button.tag == 2 {
            let vc = FilterViewController.loadFromNib()
            vc.viewModel.filterSortClassType = .CUFFSTYLEVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getHeaderTitle() -> String {
        return self.productOptionsArrayContainer.count > self.productOptionIndex ? self.productOptionsArrayContainer[productOptionIndex][0].title : "customer_style".localized
    }

    func setupTableView() {
        cuffStyleTblView.register(UINib(nibName: NewCuffStyleCell.cellIdentifier(),
                                        bundle: nil),
                                  forCellReuseIdentifier: NewCuffStyleCell.cellIdentifier())
        cuffStyleTblView.separatorStyle = .none
        cuffStyleTblView.estimatedRowHeight = 260
        cuffStyleTblView.rowHeight = UITableView.automaticDimension
    }
}


extension CuffStyleVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if productOptionsArrayContainer.count > 0 {
            return productOptionsArrayContainer[productOptionIndex].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewCuffStyleCell") as? NewCuffStyleCell else  {
            return UITableViewCell()
        }
        cell.cellDelegate = self
        cell.styleCollectionView.tag = indexPath.row
        cell.setStyleData(optionsData: productOptionsArrayContainer[productOptionIndex][indexPath.row])
        cell.contentView.clipsToBounds = false
        return cell
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView?{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.bounds.width - 30, height: 50.0))
        label.numberOfLines = 0
        label.text = "\(self.getHeaderTitle())"
        label.font = UIFont(customFont: CustomFont.FuturanBold, withSize: 18)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension CuffStyleVC: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: CuffStyleCollectionCell?,
                        index: Int,
                        didTappedInTableViewCell: NewCuffStyleCell,
                        optionId:String,
                        mainListOptionId :String) {
        if productOptionsArrayContainer[productOptionIndex].count > 1 {
            for (arrayIndex,_) in productOptionsArrayContainer[productOptionIndex].enumerated() {
                if arrayIndex > index {
                    productOptionsArrayContainer[productOptionIndex].remove(at: productOptionsArrayContainer[productOptionIndex].count - 1)
                    cuffStyleTblView.reloadData()
                }
            }
        }
        
        for productOptions in viewModel.productOption {
            for optionValues in productOptions.values {
                if optionValues.field_hidden_dependency.count > 0 {
                    for childOptionId in optionValues.field_hidden_dependency {
                        if optionId == childOptionId.child_option_id {
                            productOptionsArrayContainer[productOptionIndex].append(productOptions)
                            cuffStyleTblView.reloadData()
                            return
                        } else {
                            
                        }
                    }
                } else if (index == 2 && productOptions.main_option_id == "11296" && productOptionIndex == 0)
                            || (index == 1 && productOptions.main_option_id == "11301" && productOptionIndex == 1)
                            || ((index == 0 || index == 1) && productOptions.main_option_id == "11304" && productOptionIndex == 2)
                            || (index == 0 && productOptions.main_option_id == "11305" && productOptionIndex == 3) || productOptionIndex == 4   {
                    
                    if productOptionIndex == 4 {
                        nextButtonHeightConstraint.constant = 84
                        nextButton.setTitle("go_to_basket".localized,for: .normal)
                    } else {
                        self.delay(0.2) {
                            self.btnNextAction(self.nextButton ?? nil)
                        }
                        nextButton.setTitle("\(TITLE.style_next.localized): \(productOptions.title)", for: .normal)
                    }
                    currentProductOtpionArray = [productOptions]
                    return
                }
            }
        }
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        productOptionIndex += 1
        productOptionsArrayContainer[productOptionIndex] = currentProductOtpionArray
        if productOptionIndex == 5 {
            let userProfile = Profile.loadProfile()
            self.viewModel.customer_id = (userProfile?.id) ?? 0
            self.viewModel.quantity = "\(COMMON_SETTING.quantity)"
            self.viewModel.delivery_date = COMMON_SETTING.deliveryDate
            var i = 0
            for finalOptions in productOptionsArrayContainer {
                i = i + 1
                if i <= 5 {
                    for finalValues in finalOptions {
                        for finalChecked in finalValues.values {
                            if finalChecked.isChecked {
                                self.viewModel.styleDic.append(["parent_id": finalChecked.parent_option_id, "child_id": finalChecked.option_id , "price" : finalChecked.priceFormatted])
                            }
                        }
                    }
                }
            }
            setProductDetails()
        } else {
            cuffStyleTblView.reloadData()
        }
    }
}

//MARK:- APICALL
extension CuffStyleVC {
    
    func webServiceCallForProductOptions() {
        self.viewModel.getProductOptions {
            self.productOptionsArray.append(self.viewModel.productOption[0])
            for (_, optionsData) in self.viewModel.productOption.enumerated() {
            innerLoop:for values in optionsData.values {
                if values.field_hidden_dependency.count > 0 {
                    self.productOptionsArrayContainer.append(self.productOptionsArray)
                    break innerLoop
                }
            }
            }
            self.navigationItem.title = self.getHeaderTitle()
            self.cuffStyleTblView.reloadData()
        }
    }
    
    func setProductDetails() {
        self.viewModel.setProductDetails {
            self.setTabBarIndex(index: 2)
        }
    }
}
