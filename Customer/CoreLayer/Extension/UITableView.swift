//
//  UITableView.swift
//  Demo
//
//  Created by Arvind Vlk on 04/01/18.
//  Copyright © 2018 Arvind Vlk. All rights reserved.
//

import UIKit
import Foundation

let bgView = UIView()
let topLabel = UILabel()
let bottomLabel = UILabel()
let imageView = UIImageView()
var refreshControl: UIRefreshControl!

extension UITableView {

    
    func removeFootView() {
        self.backgroundView = nil
        tableFooterView = UIView(frame: CGRect.zero)
        self.isScrollEnabled = true
    }
    
    func emptyBgViewLatest(top:String = "", bottom:String = "", width:CGFloat = (APP_DELEGATE.window?.frame.size.width)!,  height:CGFloat = (APP_DELEGATE.window?.frame.size.height)!) {
        
        bgView.frame = self.bounds
        bgView.tag = 101
        setupLabelsnew(top: top, bottom: bottom, isImage: false,width: width,height: height)
        bgView.addSubview(topLabel)
        bgView.addSubview(bottomLabel)
        
        self.backgroundView = bgView
        self.isScrollEnabled = true
    }
    
    func setupLabelsnew(top: String, bottom: String, isImage:Bool,width:CGFloat = (APP_DELEGATE.window?.frame.size.width)!,  height:CGFloat = (APP_DELEGATE.window?.frame.size.height)!) {
        
        if isImage {
            topLabel.frame = CGRect(x: 20, y: height/2 - 30 , width: width - 40, height: 30)
        } else {
            topLabel.frame = CGRect(x: 20, y: height/2 - 50 , width: width - 40, height: 30)
        }
        
        topLabel.text = top
        topLabel.textColor = UIColor.darkGray
        topLabel.font = UIFont.systemFont(ofSize: 20)
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 1
        
        bottomLabel.frame = CGRect(x: 20, y: topLabel.frame.maxY - 30 , width: width - 40, height: 100)
        bottomLabel.text = bottom
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.font = UIFont.systemFont(ofSize: 15)
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
    }
    
    func addPullRefreshController() {
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            refreshControl?.backgroundColor = UIColor.clear
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            refreshControl?.tintColor = UIColor.darkGray
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            self.addSubview(refreshControl!)
        } else {
            // Fallback on earlier versions
        };if #available(iOS 10.0, *) {
            self.addSubview(refreshControl!)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func refreshTableView() {
        self.backgroundView = nil
        tableFooterView = UIView(frame: CGRect.zero)
        if #available(iOS 10.0, *) {
            self.refreshControl?.endRefreshing()
        } else {
            // Fallback on earlier versions
        }
    }

    func emptyBgView(imageName:String = "", top:String = "", bottom:String = "") {
        
        bgView.frame = self.frame
        setupLabels(top: top, bottom: bottom)
        setupImageView(name: imageName)
        bgView.addSubview(imageView)
        bgView.addSubview(topLabel)
        bgView.addSubview(bottomLabel)
        
        self.backgroundView = bgView
        self.isScrollEnabled = false
    }
    
    func setupImageView(name: String) {
        
        imageView.frame = CGRect(x: (bgView.bounds.size.width)/2 - 50, y: (bgView.bounds.size.height)/2 - 150 , width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.init(named: name)
        imageView.tintColor = UIColor.clear
    }

    func setupLabels(top: String, bottom: String) {
        
        topLabel.frame = CGRect(x: 20, y: imageView.frame.maxY , width: (bgView.bounds.size.width) - 40, height: 30)
        topLabel.text = top
        topLabel.textColor = UIColor.darkGray
        topLabel.font = UIFont.init(customFont: .ElMessiriR, withSize: 20)
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 1

        bottomLabel.frame = CGRect(x: 20, y: topLabel.frame.maxY , width: (bgView.bounds.size.width) - 40, height: 100)
        bottomLabel.text = bottom
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.font = UIFont.init(customFont: .ElMessiriR, withSize: 13)
        bottomLabel.numberOfLines = 0
        bottomLabel.textAlignment = .center
    }
}

extension UITableView {
    /*
     * Method name: registerCellNib
     * Description: use to register cell
     * Parameters: identifier of the cell
     * Return:  -
     */
    func registerCellNib(_ identifier: String) {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
        estimatedRowHeight = 55
        rowHeight = UITableView.automaticDimension
        tableFooterView = UIView()
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }

    /*
     * Method name: registerHeaderFooterViewNib
     * Description: use to register footer view
     * Parameters: identifier of the view
     * Return:  -
     */
    func registerHeaderFooterViewNib(_ identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /*
     * Method name: registerHeaderFooterViewNib
     * Description: use to register footer view
     * Parameters: nibName of the view, identifier of the view
     * Return:  -
     */
    func registerHeaderFooterViewNib(_ nibName: String, identifier: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }

    func sizeHeaderToFit() {
        guard let headerView = self.tableHeaderView else {
            return
        }

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        tableHeaderView = headerView
    }

    func headerViewHeight() -> CGFloat {
        guard let headerView = self.tableHeaderView else {
            return 0.0
        }

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = headerView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize).height
        return height
    }
}

class CustomTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
}
