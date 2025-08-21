//
//  ProductSizeViewModel.swift
//  Customer
//
//  Created by webwerks on 4/19/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ProductSizeViewModel: NSObject
{
    var value : String = ""
    var isDisable : Bool = false

    init(value : String, isDisable : Bool)
    {
        self.value = value
        self.isDisable = isDisable
    }
}
