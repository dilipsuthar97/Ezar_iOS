//
// LandingViewController.swift
//  Customer
//
//  Created by Webwerks on 14/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, ButtonActionDelegate{
    
    //MARK: - Variables declaration
    @IBOutlet weak var signInButton: ActionButton!
    @IBOutlet weak var signUpButton: ActionButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlImgVw: UIImageView!
    @IBOutlet weak var btnSkip: UIButton!
    
    var bottomView = ContainerView()
    var viewModel : LandingViewModel = LandingViewModel()
    var titlesArray = ["Shop your favorite clothes from \n The best stores", "Separate your dress on how you are \n and pick it up in less time", "Safe and stable payment methods to \n complete your request", "We deliver your order to your \n doorstep in a short time"]
    var descriptionArray = ["Shop the best clothes from hundreds of premium \n stores Kingdom level", "Tailor your dress to your taste in the most skilled \n factories and tailors around you", "We offer a package of the best payment methods to \n complete your order And drive it confidently \n and safely", "The safest and most stable delivery methods for \n delivery Your requests are up to you"]
    var pageControlImg:[String] = ["page1.png","page2.png","page3.png","page4.png"]
    var imageArray:[String] = ["onboarding1.png","onboarding2.png","onboarding3.png","onboarding4.png"]
    
    var currPageIndex:Int = 0
    
    //MARK :-View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        customBottonBar()
        initialize()
        imageView.layer.cornerRadius = 12
      
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        self.viewModel.getConfigurationDetails {
            if self.viewModel.configurationDetails?.men_woman == 1 {
                LocalDataManager.setGenderSelectionFlag(GenderSelectionAllowed.Allowed.rawValue)
                //LocalDataManager.setGenderSelectionFlag(GenderSelectionAllowed.NotAllowed.rawValue)
            } else {
                LocalDataManager.setGenderSelectionFlag(GenderSelectionAllowed.NotAllowed.rawValue)
            }
            
            if self.viewModel.configurationDetails?.readymade_custommade == 1 {
                LocalDataManager.setProductTypeSelectionFlag(ProductTypeSelectionAllowed.Allowed.rawValue)
            } else {
                LocalDataManager.setProductTypeSelectionFlag(ProductTypeSelectionAllowed.NotAllowed.rawValue)
            }
            
            if self.viewModel.configurationDetails?.my_tailor_measurements == 1 {
                LocalDataManager.setMyTailorMeasurementFlag(MyTailorMeasurementSelectionAllowed.Allowed.rawValue)
            } else {
                LocalDataManager.setMyTailorMeasurementFlag(MyTailorMeasurementSelectionAllowed.NotAllowed.rawValue)
            }
            
            if self.viewModel.configurationDetails?.my_previous_measurements == 1 {
                LocalDataManager.setMyPreviousTailorMeasurementFlag(MyPreviousMeasurementSelectionAllowed.Allowed.rawValue)
            } else {
                LocalDataManager.setMyPreviousTailorMeasurementFlag(MyPreviousMeasurementSelectionAllowed.NotAllowed.rawValue)
            }
            
            if self.viewModel.configurationDetails?.scan_body_measurements == 1 {
                LocalDataManager.setScanBodyMeasurementFlag(ScanBodyMeasurementSelectionAllowed.Allowed.rawValue)
            } else {
                LocalDataManager.setScanBodyMeasurementFlag(ScanBodyMeasurementSelectionAllowed.NotAllowed.rawValue)
            }
            
            if self.viewModel.configurationDetails?.own_fabrics == 1 {
                LocalDataManager.setMyOwnFabricSelectionFlag(OwnFabricSelectionAllowed.Allowed.rawValue)
            } else {
                LocalDataManager.setMyOwnFabricSelectionFlag(OwnFabricSelectionAllowed.NotAllowed.rawValue)
            }
            
            if LocalDataManager.getGenderSelectionFlag() == 0 {
                LocalDataManager.setGenderSelection(GenderSelection.MEN.rawValue)
            }
            
            if LocalDataManager.getProductTypeSelectionFlag() == 0 {
                LocalDataManager.setUserSelection(ProductType.CustomMade.rawValue)
            }
            
            if !(LocalDataManager.getFirstTimeInstall()) {
                LocalDataManager.setFirstTimeInstall(_isFirstTime: true)
                EzarApp.setRootViewController(type: SelectLanguageViewController.self)
            } else {
                if Profile.loadProfile() == nil {
                    EzarApp.setRootViewController(type: SelectLanguageViewController.self)
                } else {
                    if LocalDataManager.getGenderSelection() == GenderSelection.NONE.rawValue{
                        EzarApp.setRootViewController(type: GenderSelectionVC.self)
                    } else {
                        APP_DELEGATE.setHomeView()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        let navigation = self.navigationController as! AVNavigationController
        navigation.statusBarColor(color: .clear)
    }
    
    func configUI() {
    
    }
    
        func initialize() {
            self.titleLabel.text = TITLE.onboarding_title1.localized
            self.descLabel.text = TITLE.onboarding_description1.localized
        }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
            
        if (sender.direction == .left) {
                print("Swipe Left")
            if(currPageIndex < titlesArray.count - 1) {
                currPageIndex += 1
                titleLabel.text = titlesArray[currPageIndex]
                descLabel.text = descriptionArray[currPageIndex]
                imageView.image = UIImage.init(named: "onboarding\(currPageIndex + 1)")
                pageControlImgVw.image = UIImage.init(named: "\(pageControlImg[currPageIndex])")
                btnSkip.isHidden = false
            }
        }
            
        if (sender.direction == .right) {
            print("Swipe Right")
            if(currPageIndex > 0) {
                currPageIndex -= 1
                titleLabel.text = titlesArray[currPageIndex]
                descLabel.text = descriptionArray[currPageIndex]
                imageView.image = UIImage.init(named: "onboarding\(currPageIndex + 1)")
                pageControlImgVw.image = UIImage.init(named: "\(pageControlImg[currPageIndex])")
                btnSkip.isHidden = false
            }
        }
        pageControl.currentPage = currPageIndex
        if(currPageIndex == titlesArray.count - 1) {
        
            btnSkip.isHidden = true

        } else {
            
        }
    }
    
    @IBAction func skipbtnTapped(_ sender: Any) {
        let vc = LoginViewController.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.customer_signup.localized.uppercased(),TITLE.SIGNIN.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 55)
        self.bottomView.buttonArray = buttonArray
        //self.view.addSubview(self.bottomView)
    }
    
    func onClickBottomButton(button: UIButton) {
        if button.tag == 0 {
            //Sign Up
            let vc = RegisterViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }  else {
            //Sign In
            let vc = LoginViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
