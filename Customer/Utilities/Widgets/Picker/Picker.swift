//
//  Picker.swift
//  GIS-Agent
//
//  Created by Akshaykumar Maldhure on 8/2/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import UIKit

class Picker: UIPickerView {
    typealias CompletionHandler = (_ item : String, _ row : Int) -> ()

    var selectedIndex: Int = 0 {
        didSet {
            selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    var data : [String] = []
    var completion : CompletionHandler? = nil

    func setPickerView(with data : [String], status : Bool = false, selectedItem: @escaping CompletionHandler){
        self.delegate = self
        self.dataSource = self
        self.data = data
        completion = selectedItem
        self.backgroundColor = UIColor.white
    }
}

extension Picker : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (self.data[row]) as String
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: (self.data[row]) as String, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
        if row < self.data.count{
            completion!((self.data[row]), row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
}
