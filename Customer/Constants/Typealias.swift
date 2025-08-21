//
//  Typealias.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation

typealias anyString = [String: String]
typealias anyDict = [String: Any]

typealias isCompleted = () -> Void
typealias JSONCompletionHandler = (String?) -> Void
typealias completionHandler = JSONCompletionHandler
