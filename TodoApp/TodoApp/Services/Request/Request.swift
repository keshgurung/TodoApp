//
//  Request.swift
//  TodoApp
//
//  Created by Kesh Gurung on 03/11/2023.
//

import Foundation

protocol Requestable {
    var baseUrl: String {get}
    var path: String {get set}
    var params: [String: Any] {get}
    var type: String {get}
    var header: [String: String] {get}
    func createUrlRequest() -> URLRequest?
}

extension Requestable {
    var baseUrl: String {
        return EndPoint.baseUrl.rawValue
    }
    var params: [String: Any] {
        return [:]
    }
    var type: String {
        return type
    }
    var header: [String: String] {
        return [:]
    }
    
    func createUrlRequest() -> URLRequest? {
        guard baseUrl.count > 0, path.count > 0 else { return nil }
        var urlComponents = URLComponents(string:baseUrl + path)
        if type == "GET" {
            urlComponents?.queryItems = params.map {
                URLQueryItem(name:$0, value: $1 as? String)
            }
        }
        guard let url = urlComponents?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = type // GET, DELETE, POST, PUT
        
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if type == "POST" || type == "PUT" {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonBody = params
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
                request.httpBody = jsonData
                print(params)
            } catch {
                print("Error converting JSON data: \(error)")
                return nil
            }
        }
        return request
    }
}
