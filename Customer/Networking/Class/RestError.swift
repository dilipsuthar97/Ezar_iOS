//
//  ServiceError.swift
//  NexinoMovies
//
//  Created by webwerks on 08/01/18.
//  Copyright © 2017 webwerks. All rights reserved.
//

import UIKit

public struct ERROR_MSG {
    static let Unknown = "Unknown error occurred."
    static let Wrong = "Something went wrong."
    static let TimeOut = "customer_Time_Out"
    static let kServerError   = "customer_kServerError"
    static let InvalidAcess = "Invalid Access"
    
}

class RestError: Error {
    
    public var code: Int = -1
    public var message: String = ERROR_MSG.Unknown
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}


