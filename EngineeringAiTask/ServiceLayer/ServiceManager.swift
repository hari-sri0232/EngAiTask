//
//  ServiceManager.swift
//  EngineeringAiTask
//
//  Created by Sri Hari on 06/03/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit

class ServiceManager {
    
    static let sharedInstance: ServiceManager? = {
        let shared = ServiceManager()
        return shared
    }()
    //Initialize Urlsession
    func getUrlSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.httpAdditionalHeaders = ["Content-Type":"application/Json"]
        configuration.timeoutIntervalForRequest = 100
        let session = URLSession(configuration: configuration)
        return session
    }
    //Fetch data from server
    func makeServerRequest(with baseUrl: String?, parameters: [String:Any]?, completionHandler:@escaping([String:Any]?, StatusMessage?)->Void) {
        guard let url = URL(string: baseUrl ?? "") else { return  }
        var urlRequest = URLRequest(url: url)
        if parameters?.isEmpty == true {
            urlRequest.httpMethod = HttpMethod.get.rawValue
        }else {
            urlRequest.httpMethod = HttpMethod.post.rawValue
            guard let data = try? JSONSerialization.data(withJSONObject: parameters as Any, options: .prettyPrinted) else { return }
            urlRequest.httpBody = data
        }
        let dataTask = getUrlSession().dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil,.error)
                }
                return
            }
            guard let responseData = data else {
                DispatchQueue.main.async {
                    completionHandler(nil,.failure)
                }
               return
            }
            do {
                guard let responseObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? [String:Any] else {
                    DispatchQueue.main.async {
                        completionHandler(nil,.failure)
                    }
                return
                }
                let removeNullValues = responseObject.compactMapValues { $0 }
                print(removeNullValues)
                DispatchQueue.main.async {
                    completionHandler(removeNullValues,.success)
                }
            }
        }
        dataTask.resume()
    }
}
