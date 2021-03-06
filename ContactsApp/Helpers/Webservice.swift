//
//  Webservice.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum Completion {
    case Success(Any)
    case Failure(String)
}

enum HTTPMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
}

enum WebServiceEndPoint: String {
    
    case BaseURL = "http://gojek-contacts-app.herokuapp.com"
    case GetContacts = "/contacts.json"
    case ContactOperations = "/contacts/"
}

enum WebServiceRoute {
    
    case GetContacts(WebServiceEndPoint)
    case ContactOperations(WebServiceEndPoint, String)
    
    var Route: String {
        switch self {
        case .GetContacts(let url):
            return "\(WebServiceEndPoint.BaseURL.rawValue)\(url.rawValue)"
        case let .ContactOperations(url, id):
            return "\(WebServiceEndPoint.BaseURL.rawValue)\(url.rawValue)\(id).json"
        }
    }
}

class WebService {

    static let shared = WebService()
    
    func request(method: HTTPMethod, url: WebServiceRoute, parameters: Any? = nil, completionClosure: @escaping (Completion) -> ()) {
        
        guard let dataSourceURL = URL(string: url.Route) else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var request = URLRequest(url: dataSourceURL)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestBody = parameters as? [String:Any] {
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        }
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completionClosure(.Failure(error!.localizedDescription))
                }
                return
            }
            
            do {
                let dataSource = try JSONSerialization.jsonObject(with: data)
                DispatchQueue.main.async {
                    completionClosure(.Success(dataSource))
                }
            } catch {
                DispatchQueue.main.async {
                    completionClosure(.Failure("No data found"))
                }
            }
        }
        task.resume()
    }
}
