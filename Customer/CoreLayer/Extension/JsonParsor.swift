
//
//  JsonParsor.swift
//  Sample
//
//  Created by Volkoff India on 15/06/21.
//

import Foundation

extension KeyedDecodingContainer {
   
    func decodeSafelyIfPresent<T>(_ key: K) throws -> T?
        where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key)
    }
}
