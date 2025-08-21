//
//  ImageIntroductionViewController.swift
//  Customer
//
//  Created by Shruti Gupta on 1/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class ImageIntroductionViewController: UIViewController {
    
    //MARK:- Veriacble declation
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipBtn: ActionButton!
    let viewModel :ImageIntroViewModel = ImageIntroViewModel()
    var skipButtonPress :Bool = true
    var lastButtonPress :Bool = true
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callImageIntroWS()
    }
    
    //MARK:- Helpers for data & UI
    func setupColletionView() {
        collectionView.register(UINib(nibName: ImageIntroductionCollectionViewCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: ImageIntroductionCollectionViewCell.cellIdentifier())
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: true)
        pageControl.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        skipBtn.isHidden = true
        skipBtn.setTitle(TITLE.customer_skip.localized, for: .normal)
        
        skipBtn.touchUp = { button in
           self.skipButtonPress = false
            let vc = LoginViewController.loadFromNib()
            vc.isFromIntroImages = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- api call
    func callImageIntroWS(){
        
        self.viewModel.language = COMMON_SETTING.lang
        
        viewModel.getIntroImagesWS {
            self.collectionView.reloadData()
        
            if self.viewModel.imageArray?.count ?? 0 > 0{
                self.skipBtn.isHidden = false
            }
            
            if self.viewModel.imageArray?.isEmpty ?? true{
                let vc = LoginViewController.loadFromNib()
                vc.isFromIntroImages = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if let imageArray = self.viewModel.imageArray{
                if imageArray.count == 1{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            if self.skipButtonPress {
                                let vc = LoginViewController.loadFromNib()
                                vc.isFromIntroImages = true
                                self.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                }
            }
        }
    }
    
    //MARK:- scrollView methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if let imageArray = self.viewModel.imageArray{
            if (pageControl.currentPage == imageArray.count - 1) && lastButtonPress  {
                lastButtonPress = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    if self.skipButtonPress{
                        let vc = LoginViewController.loadFromNib()
                        vc.isFromIntroImages = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
        }
    }
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate
extension ImageIntroductionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageArray = self.viewModel.imageArray{
            return imageArray.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageIntroductionCollectionViewCell.cellIdentifier(), for: indexPath) as! ImageIntroductionCollectionViewCell
        
        if let imageArray = self.viewModel.imageArray{
            if let imageUrl = imageArray[indexPath.row].image, !(imageUrl.isEmpty)
            {
                let imageUrlString = URL.init(string: imageUrl)
                cell.imageView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
            }
            
            pageControl.numberOfPages = imageArray.count
            pageControl.isHidden = !(imageArray.count > 0)
        }
        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension ImageIntroductionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = UIScreen.main.bounds.width
        let height : CGFloat = UIScreen.main.bounds.height
        return CGSize(width: width, height: height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
}
