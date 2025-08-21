//
//  NSObjectExtension.swift
//  GIS-Agent
//
//  Created by Akshaykumar Maldhure on 9/23/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    public class var nameOfClass: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var nameOfClass: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
}
