//
//  NetworkManager.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Alamofire
import Foundation

let TIME_OUT = 80.0
let INetworkManager = NetworkManager.sharedInstance

class NetworkManager {
    
    class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }

    /*
     * Method name: Request
     * Description: Get data from server
     * Parameters: param and completion handler
     * Return:  - Data
     */
    func performRequest(url: String,
                        method: HTTPMethod = .post,
                        param: anyDict? = nil,
                        headers: Headers = HEADERS.urlEncoded,
                        completionHandler: @escaping JSONCompletionHandler) {
        
        var parameters: Parameters?
        if let temp = param {
            parameters = temp as Parameters
        }

        print("URL: \(url)")
        if let result = param as? NSDictionary {
            print("Request: \(result)")
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TIME_OUT
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.request(url,
                               method: method,
                               parameters: parameters,
                               encoding: URLEncoding.methodDependent,
                               headers: setHeaders(headers: headers))
        .responseJSON {
            response in
            sessionManager.session.invalidateAndCancel()
            sessionManager.session.finishTasksAndInvalidate()
            
            switch (response.result) {
            case .success:
                
                IProgessHUD.dismiss()
                if let result: NSDictionary = response.value as? NSDictionary {
                    let responsedict = result
                    print("Response: \(responsedict)")
                    
                    if let data = response.data,
                       let json = String(data: data, encoding: String.Encoding.utf8) {
                        let response = BaseResponse(JSONString: json)
                        
                        if let success = response?.status, !success {
                            DispatchQueue.main.async {
                                if let message = response?.message {
                                    INotifications.show(message: message)
                                }
                            }
                        }
                        //retrun with JSON
                        completionHandler(json)
                    }
                }
                break
            case .failure(let error):
                print("ERROR:: \(error.localizedDescription)")
                IProgessHUD.dismiss()
                if error._code == NSURLErrorTimedOut ||
                    error._code == NSURLErrorNotConnectedToInternet {
                    INotifications.show(message: ERROR_MSG.TimeOut.localized)
                } else {
                    INotifications.show(message: ERROR_MSG.kServerError.localized)
                }
                completionHandler(nil)
                break
            }
        }
    }

    /*
     * Method name: Request for Upload
     * Description: Upload media on server
     * Parameters: param and completion handler
     * Return:
     */
    func multipartRequest(param : Parameters?,
                           data : [MultipartFile]?,
                           endPointUrl : String,
                           headers: Headers = HEADERS.urlEncoded,
                           completion: @escaping JSONCompletionHandler) {
        
        print("URL: \(endPointUrl)")
        if let result = param as? NSDictionary {
            print("Request: \(result)")
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TIME_OUT
        
        var parameters : Parameters? = nil
        if let temp = param{
            parameters = temp
        }
                
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                             withName: key as String)
                }
            }
            
            if let data = data {
                for file in data {
                    multipartFormData.append(file.data,
                                             withName: file.name,
                                             fileName: file.fileName,
                                             mimeType: file.mimeType)
                }
            }
            
        }, usingThreshold: UInt64.init(),
                         to: endPointUrl,
                         method: .post,
                         headers: setHeaders(headers: headers)) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    IProgessHUD.dismiss()
                    if let result: NSDictionary = response.value as? NSDictionary {
                        let responsedict = result
                        print("Response: \(responsedict)")
                        
                        if let data = response.data,
                           let json = String(data: data, encoding: String.Encoding.utf8) {
                            let response = BaseResponse(JSONString: json)
                            
                            if let success = response?.status, !success {
                                DispatchQueue.main.async {
                                    if let message = response?.message {
                                        INotifications.show(message: message)
                                    } else {
                                        INotifications.show(message: ERROR_MSG.TimeOut.localized)
                                    }
                                }
                            }
                            //retrun with JSON
                            completion(json)
                        }
                    } else {
                        INotifications.show(message: ERROR_MSG.kServerError.localized)
                    }
                }
                break
            case .failure(let error):
                print("ERROR:: \(error.localizedDescription)")
                if error._code == NSURLErrorTimedOut ||
                    error._code == NSURLErrorNotConnectedToInternet {
                    INotifications.show(message: ERROR_MSG.TimeOut.localized)
                } else {
                    INotifications.show(message: ERROR_MSG.kServerError.localized)
                }
                completion(nil)
                break
            }
        }
    }
    
    /*
     * Method name: Request for Upload
     * Description: Upload media on server
     * Parameters: param and completion handler
     * Return:
     */
    func multipartRequestJPEG(param : Parameters?,
                           data : [MultipartFileJPEG]?,
                           endPointUrl : String,
                           headers: Headers = HEADERS.urlEncoded,
                           completion: @escaping JSONCompletionHandler) {
        
        print("URL: \(endPointUrl)")
        if let result = param as? NSDictionary {
            print("Request: \(result)")
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TIME_OUT
        
        var parameters : Parameters? = nil
        if let temp = param{
            parameters = temp
        }
                
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                             withName: key as String)
                }
            }
            
            if let data = data {
                for file in data {
                    multipartFormData.append(file.data,
                                             withName: file.name,
                                             fileName: file.fileName,
                                             mimeType: file.mimeType)
                }
            }
            
        }, usingThreshold: UInt64.init(),
                         to: endPointUrl,
                         method: .post,
                         headers: setHeaders(headers: headers)) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    IProgessHUD.dismiss()
                    if let result: NSDictionary = response.value as? NSDictionary {
                        let responsedict = result
                        print("Response: \(responsedict)")
                        
                        if let data = response.data,
                           let json = String(data: data, encoding: String.Encoding.utf8) {
                            let response = BaseResponse(JSONString: json)
                            
                            if let success = response?.status, !success {
                                DispatchQueue.main.async {
                                    if let message = response?.message {
                                        INotifications.show(message: message)
                                    } else {
                                        INotifications.show(message: ERROR_MSG.TimeOut.localized)
                                    }
                                }
                            }
                            
                            //retrun with JSON
                            completion(json)
                        }
                    } else {
                        INotifications.show(message: ERROR_MSG.kServerError.localized)
                    }
                }
                break
            case .failure(let error):
                print("ERROR:: \(error.localizedDescription)")
                if error._code == NSURLErrorTimedOut ||
                    error._code == NSURLErrorNotConnectedToInternet {
                    INotifications.show(message: ERROR_MSG.TimeOut.localized)
                } else {
                    INotifications.show(message: ERROR_MSG.kServerError.localized)
                }
                completion(nil)
                break
            }
        }
    }
}

/*
 * Method name: NetworkManager
 * Description: This func use for shared Instance
 * Return: singleton
 */
extension NetworkManager {
    func setHeaders(headers: Headers) -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": headers.ContentType,
            "Accept": headers.Accept,
            "cache-control": headers.cache,
            "username": keys.headerName,
            "password": keys.headerPassword,
            API_KEYS.lang: COMMON_SETTING.lang,
        ]
        return headers
    }
}
