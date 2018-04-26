//
//  MSError.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 24/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

public enum MSError {
    case error(Error)
    case responseError(ResponseError)
    case message(title:String, message: String)
    case httpUrlResponse(response: HTTPURLResponse)
    
    var message : String {
        switch self {
        case .error(let error):
            if let _ = error as? URLError {
                return "ERROR_INTERNET".localized
            } else {
                return "ERROR_UNKNOWN".localized
            }
        case .responseError(let response):
            return response.detail
        case .message(_, let message):
            return message
        case .httpUrlResponse(let response):
            return "An error has occured (status: \(response.statusCode))"
        }
    }
}
