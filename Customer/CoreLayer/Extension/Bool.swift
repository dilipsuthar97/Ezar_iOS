//
//  Bool.swift
//  Business
//
//  Created by Volkoff on 28/04/22.
//

import Foundation

extension Bool {

    init(_ string: String?) {
        guard let string = string else { self = false; return }
        
        switch string.lowercased() {
        case "true", "yes", "1":
            self = true
        default:
            self = false
        }
    }
    
    var intValue: Int {
        return self ? 1 : 0
    }

}
