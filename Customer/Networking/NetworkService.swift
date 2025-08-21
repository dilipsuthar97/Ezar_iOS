//
//  NetworkService.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

class URLs {
    /*
     * Method name: baseURL
     * Description: use to get network Environment
     * Return: development / production
     */
    static var networkEnvironment: NetworkEnvironment {
        #if DEBUG
            return .production
        #else // arvdvlk
            return .production
        #endif
    }

    /*
     * Method name: baseURL
     * Description: use to get base of the service
     * dev: http://alnaseej.php-dev.in/
        Prod: https://ezarksa.com/
     */
    static var baseURL: String {
        switch networkEnvironment {
        case .development:
            return "http://alnaseej.php-dev.in/"
        default:
            return "https://ezarksa.com/"
        }
    }

    static var apiKey: String {
        switch networkEnvironment {
        case .development:
            return  ""
        default:
            return ""
        }
    }

    /*
     * Method name: find Repositories
     * Description: This func use to get full URLs
     * Return: https Urls
     */
    static func findRepositories(_ endpoint: String) -> String {
        let api = baseURL + endpoint
        return api
    }
}
