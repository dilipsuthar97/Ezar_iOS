//
//  NumberFormat.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    
    var toDouble: Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0.0
    }
    
    var toInt: Int {
        return Int((self as NSString).intValue)
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func addCurrnecy() -> String {
        return "£" + self.clean
    }
    
    var clean: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        }
        return String(format: "%0.2f", self)
    }
}

extension Int {
    var stringValue: String {
        return description
    }

    func addCalories() -> String {
        return String(self) + " Kcal"
    }
}

extension Float {
    func truncateDouble(place : Int)-> Float {
        return Float(floor(pow(10.0, Float(place)) * self)/pow(10.0, Float(place)))
    }
}
