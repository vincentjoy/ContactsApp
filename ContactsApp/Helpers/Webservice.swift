//
//  Webservice.swift
//  ContactsApp
//
//  Created by Vincent Joy on 05/02/19.
//  Copyright © 2019 Contacts. All rights reserved.
//

import UIKit

enum Completion {
    case success(Any)
    case failure(Error)
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
}

enum WebServiceEndPoint: String {
    
    case BaseURL = "http://gojek-contacts-app.herokuapp.com"
    case GetContacts = "/contacts.json"
    case ContactOperations = "/contacts/"
}

enum WebServiceRoute {
    
    case GetContacts(WebServiceEndPoint, WebServiceEndPoint)
    case ContactOperations(WebServiceEndPoint, WebServiceEndPoint, String)
    
    var Route: String {
        switch self {
        case let .GetContacts(baseURL, url):
            return "\(baseURL.rawValue)\(url.rawValue)"
        case let .ContactOperations(baseURL, url, id):
            return "\(baseURL.rawValue)\(url.rawValue)\(id).json"
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
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            
            if let data = data {
                do {
                    
                    if let dataSource = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    } else {
                        print("Error")
                    }
                    
                } catch {
                    print("Error")
                }
            }
            
            if error != nil {
                print("Error")
            }
        }
        
        task.resume()
    }
}
