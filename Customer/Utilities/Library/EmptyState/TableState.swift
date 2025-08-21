//
//  CustomState.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 24/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit
import Alamofire

enum TableState: CustomState {
    case noResult
    case noData
    case noCart
    case noSearch


    var image: UIImage? {
        switch self {
        case.noResult:
            return UIImage(named: "bag_Icon")
        case .noCart:
            return UIImage(named: "bag_Icon")
        case .noSearch:
            return UIImage(named: "bag_Icon")
        default:
            return nil
        }
    }
    
    var title: String? {
        switch self {
        case .noResult: return "customer_noData_available".localized
        case .noData: return "NE_GENERIC_ERROR_TITLE".localized
        case .noCart: return "customer_empty_shopping_bag".localized
        case .noSearch: return "customer_noData_available".localized
        }
    }
    
    var description: String? {
        switch self {
        case .noResult: return ""
        case .noData: return "something_wrong".localized
        case .noCart: return "customer_shopping_bag_des".localized
        case .noSearch: return "customer_product_list_empty".localized
        }
    }
    
    var titleButton: String? {
        switch self {
            case .noCart: return nil
        default:
            return nil
        }
    }
}
