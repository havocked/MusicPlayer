//
//  Response.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 24/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

public struct ResponseError : Codable {
    var id: String
    var title: String
    var detail: String
}

struct Response<T: Codable> : Codable {
    var results : T?
    var errors : [ResponseError]?
    
    private enum CodingKeys: String, CodingKey {
        case results
        case errors
    }
    
    private enum ResultKeys: String, CodingKey {
        case songs
    }
    
    public init(from decoder: Decoder) throws {
        let allValues = try decoder.container(keyedBy: CodingKeys.self)
        let resultValues = try allValues.nestedContainer(keyedBy: ResultKeys.self, forKey: .results)
        results = try resultValues.decodeIfPresent(T.self, forKey: .songs)
        errors = try allValues.decodeIfPresent([ResponseError].self, forKey: .errors)
    }
}
