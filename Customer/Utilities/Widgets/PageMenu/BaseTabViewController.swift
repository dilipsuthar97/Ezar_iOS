//
//  BaseTabViewController.swift
//  Swish
//
//  Created by Jitendra Gaur on 29/08/16.
//  Copyright © 2016 Talk Agency. All rights reserved.
//

import UIKit

class BaseTabViewController: BaseViewController {
    
    var pageMenu : CAPSPageMenu?
    var parameters:[CAPSPageMenuOption]?
    var pageMenuFrame: CGRect!
    var selectModelPageMenuFrame: CGRect!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        print("SCREEN.height", MAINSCREEN.height)
        
        //iPhone X ->                     89.0                                                              130
        pageMenuFrame = CGRect(x: 0.0, y: 65.0, width: self.view.frame.width, height: self.view.frame.height-65)
        
        selectModelPageMenuFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height-65)
        
        
        if MAINSCREEN.height > 800 && MAINSCREEN.height < 860 {
            pageMenuFrame = CGRect(x: 0.0, y: 80.0, width: self.view.frame.width, height: self.view.frame.height-80)
            selectModelPageMenuFrame = CGRect(x: 0.0, y: 15.0, width: self.view.frame.width, height: self.view.frame.height-80)
        }
        if MAINSCREEN.height > 860 && MAINSCREEN.height < 900 {
            pageMenuFrame = CGRect(x: 0.0, y: 85.0, width: self.view.frame.width, height: self.view.frame.height-85)
            selectModelPageMenuFrame = CGRect(x: 0.0, y: 20.0, width: self.view.frame.width, height: self.view.frame.height-85)
        }
        if MAINSCREEN.height > 900 {
            pageMenuFrame = CGRect(x: 0.0, y: 90.0, width: self.view.frame.width, height: self.view.frame.height-90)
            selectModelPageMenuFrame = CGRect(x: 0.0, y: 25.0, width: self.view.frame.width, height: self.view.frame.height-90)
        }//90
        parameters = [
            
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            //.ViewBackgroundColor(UIColor.whiteColor()),
            .bottomMenuHairlineColor(UIColor.clear),
            .selectionIndicatorColor(UIColor(named: "BorderColor")!),
            .menuMargin(20.0),
            .menuHeight(44.0),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.gray),
            .menuItemFont(UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(false),
            .selectionIndicatorHeight(3.0),
            .menuItemSeparatorPercentageHeight(0),
            .selectionIndicatorHeight(3.0)//,.menuItemWidthBasedOnTitleTextWidth(true),//,
            //.titleTextSizeBasedOnMenuItemWidth(true)
            
        ]
        
    }
    
}
