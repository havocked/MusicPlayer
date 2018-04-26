//
//  Router.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 24/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

typealias StoreFront = String

enum Router {
    
    static let baseURLString = Bundle.main.infoDictionary!["Apple_Music_Api_Base_Url"] as! String
    static let apiVersion = Bundle.main.infoDictionary!["Apple_Music_Api_Version"] as! String
    
    /// Warning : Limit param cannot exceed 50
    case getTopChartSongs(StoreFront, limit: Int)
    
    /// Warning : Limit param cannot exceed 25
    case search(storeFront: StoreFront, query: String, limit: Int)
    
    var method : HTTPMethod {
        switch self {
        case .getTopChartSongs:
            return .get
        case .search:
            return .get
        }
    }
    
    var path : String {
        switch self {
        case .getTopChartSongs(let storeFront, _):
            return "/catalog/\(storeFront)/charts"
        case .search(let storeFront, _, _):
            return "/catalog/\(storeFront)/search"
        }
    }
    
    fileprivate var requestHeaders: [String:String] {
        var headers = [String:String]()
       
        let authKey = Bundle.main.infoDictionary!["Apple_Music_Key"] as! String
        headers["Authorization"] = "Bearer \(authKey)"

        return headers
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        case .getTopChartSongs(_, let limit):
            let typeQuery = URLQueryItem(name: "types", value: "songs")
            let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
            
            return [typeQuery, limitQuery]
        case .search(_, let query, let limit):
            let typeQuery = URLQueryItem(name: "types", value: "songs")
            let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
            let termQuery = URLQueryItem(name: "term", value: query)
            
            return [typeQuery, limitQuery, termQuery]
        }
    }
    
    func asURLRequest() -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = Router.baseURLString
        urlComponent.path = "/\(Router.apiVersion)\(path)"
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            fatalError("Url components is wrongly created!")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = requestHeaders
        
        return request
    }
}
