//
//  OnboardingsViewController.swift
//  EZAR
//
//  Created by Ankita Firake on 26/05/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class OnboardingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlImgVw: UIImageView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnConfirm: ActionButton!
    
    
    var titlesArray = ["Shop your favorite clothes from \n The best stores", "Separate your dress on how you are \n and pick it up in less time", "Safe and stable payment methods to \n complete your request", "We deliver your order to your \n doorstep in a short time"]
    var descriptionArray = ["Shop the best clothes from hundreds of premium \n stores Kingdom level", "Tailor your dress to your taste in the most skilled \n factories and tailors around you", "We offer a package of the best payment methods to \n complete your order And drive it confidently \n and safely", "The safest and most stable delivery methods for \n delivery Your requests are up to you"]
    var pageControlImg:[String] = ["page1.png","page2.png","page3.png","page4.png"]
    var imageArray:[String] = ["onboarding1.png","onboarding2.png","onboarding3.png","onboarding4.png"]
    
    var currPageIndex:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       initialize()
        imageView.layer.cornerRadius = 12
        btnConfirm.isHidden = true
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        btnSkip.layer.cornerRadius = 20
        btnSkip.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        btnSkip.layer.borderWidth = 1
        btnConfirm.layer.cornerRadius = 20
        btnConfirm.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        btnConfirm.layer.borderWidth = 1
       
    }

    func initialize() {
       
        self.btnSkip.setTitle(TITLE.SKIP.localized, for: .normal)
        self.btnConfirm.setTitle(TITLE.confirm_btn.localized, for: .normal)
        if currPageIndex == 0 {
            self.titleLabel.text = TITLE.onboarding_title1.localized
            self.descLabel.text = TITLE.onboarding_description1.localized
        } else  if currPageIndex == 1 {
            self.titleLabel.text = TITLE.onboarding_title2.localized
            self.descLabel.text = TITLE.onboarding_description2.localized
        } else  if currPageIndex == 2 {
            self.titleLabel.text = TITLE.onboarding_title3.localized
            self.descLabel.text = TITLE.onboarding_description3.localized
        } else  if currPageIndex == 3 {
            self.titleLabel.text = TITLE.onboarding_title4.localized
            self.descLabel.text = TITLE.onboarding_description4.localized
        }
      
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
                btnConfirm.isHidden = true
                
                if currPageIndex == 1 {
                    self.titleLabel.text = TITLE.onboarding_title1.localized
                    self.descLabel.text = TITLE.onboarding_description1.localized
                } else  if currPageIndex == 2 {
                    self.titleLabel.text = TITLE.onboarding_title2.localized
                    self.descLabel.text = TITLE.onboarding_description2.localized
                } else  if currPageIndex == 3 {
                    self.titleLabel.text = TITLE.onboarding_title3.localized
                    self.descLabel.text = TITLE.onboarding_description3.localized
                } else  if currPageIndex == 4 {
                    self.titleLabel.text = TITLE.onboarding_title4.localized
                    self.descLabel.text = TITLE.onboarding_description4.localized
                }
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
                btnConfirm.isHidden = true
            }
            
            if currPageIndex == 1 {
                self.titleLabel.text = TITLE.onboarding_title1.localized
                self.descLabel.text = TITLE.onboarding_description1.localized
            } else  if currPageIndex == 2 {
                self.titleLabel.text = TITLE.onboarding_title2.localized
                self.descLabel.text = TITLE.onboarding_description2.localized
            } else  if currPageIndex == 3 {
                self.titleLabel.text = TITLE.onboarding_title3.localized
                self.descLabel.text = TITLE.onboarding_description3.localized
            } else  if currPageIndex == 4 {
                self.titleLabel.text = TITLE.onboarding_title4.localized
                self.descLabel.text = TITLE.onboarding_description4.localized
            }
        }
        pageControl.currentPage = currPageIndex
        if(currPageIndex == titlesArray.count - 1) {
        
            btnSkip.isHidden = true
            btnConfirm.isHidden = false

        } else {
            
        }
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        print(currPageIndex)
        if currPageIndex == 3 {
            let vc = LoginViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if(currPageIndex < titlesArray.count - 1) {

                currPageIndex += 1
                titleLabel.text = titlesArray[currPageIndex]
                descLabel.text = descriptionArray[currPageIndex]
                imageView.image = UIImage.init(named: "onboarding\(currPageIndex + 1)")
                pageControlImgVw.image = UIImage.init(named: "\(pageControlImg[currPageIndex])")
            }
            pageControl.currentPage = currPageIndex

        }
        if(currPageIndex == titlesArray.count - 1) {
           
            btnSkip.isHidden = true
            btnConfirm.isHidden = false
    
        } else {
          

        }
        
    }
    @IBAction func btnBackAction(_ sender: Any) {
       
        if(currPageIndex > 0) {
            currPageIndex -= 1
            titleLabel.text = titlesArray[currPageIndex]
            descLabel.text = descriptionArray[currPageIndex]
            imageView.image =  UIImage.init(named: "\(imageArray[currPageIndex])")
            pageControlImgVw.image = UIImage.init(named: "\(pageControlImg[currPageIndex])")
           
            btnSkip.isHidden = false
        }
        pageControl.currentPage = currPageIndex
        if(currPageIndex == titlesArray.count - 1) {
            btnSkip.isHidden = true
        }
    }
    
    @IBAction func skipbtnTapped(_ sender: Any) {
        let vc = LoginViewController.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        let vc = LoginViewController.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
