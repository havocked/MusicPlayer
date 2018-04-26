//
//  ChartResult.swift
//  MusicPlayer
//
//  Created by Nataniel Martin on 24/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

protocol Result : Codable {
    associatedtype Item: Codable
    
    var href: String { get set }
    var next: String? { get set }
    var data: [Item] { get set }
}

struct ChartResult<T: Codable> : Result {

    typealias Item = T
    var href: String
    var next: String?
    var data: [T]

    var name: String
}

struct SearchResult<T: Codable> : Result {
    
    typealias Item = T
    var href: String
    var next: String?
    var data: [T]
}
