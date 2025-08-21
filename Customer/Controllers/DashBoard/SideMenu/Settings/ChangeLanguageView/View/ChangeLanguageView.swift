//
//  ChangeLanguageView.swift
//  Customer
//
//  Created by webwerks on 4/9/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

protocol ChangeLanguageViewDelegate
{
    func onUpdateButtonClick(selectedLanguage : Int)
}

class ChangeLanguageView: UIView {
    
    //MARK:- Required Variable
    var delegate : ChangeLanguageViewDelegate!
    @IBOutlet weak var tableView: UITableView!
    var bottomView = ContainerView()
    @IBOutlet weak var titleLabel: UILabel!

    var languageArray : [String] = [TITLE.English.localized, TITLE.Arabic.localized]
    var selectedIndex : Int = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.width, height: MAINSCREEN.height)
    }
    
    //MARK:- Helpers for data & UI
    func setUpUpdateButton()
    {
        var buttonArray : NSMutableArray = []
        buttonArray = [TITLE.UPDATE.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.addSubview(self.bottomView)
    }
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        self.titleLabel.text = TITLE.ChangeLanguage.localized
        selectedIndex = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? 0 : 1
        
        tableView.register(UINib(nibName: ChangeLanguageCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ChangeLanguageCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
}

//MARK:- TButton Action delegate method
extension ChangeLanguageView : ButtonActionDelegate {
    func onClickBottomButton(button: UIButton)
    {
        LocalDataManager.setSelectedLanguage(self.selectedIndex + 1)
        self.delegate.onUpdateButtonClick(selectedLanguage: self.selectedIndex + 1)
    }
}

//MARK:- UITable Delegate & DataSource
extension ChangeLanguageView : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChangeLanguageCell.cellIdentifier(), for: indexPath) as! ChangeLanguageCell
        cell.selectionStyle = .none
        cell.languageTitle.text = languageArray[indexPath.row]
        cell.languageView.borderColor = self.selectedIndex == indexPath.row ? UIColor(named: "BorderColor")! : UIColor.clear
        cell.languageTitle.textColor = self.selectedIndex == indexPath.row ? UIColor.black : UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
}
