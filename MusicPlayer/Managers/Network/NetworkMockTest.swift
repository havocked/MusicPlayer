//
//  NetworkMockTest.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

struct NetworkMockTest : NetworkRessource {
    func getTopCharts(storeFront: StoreFront, completionHandler: @escaping ([ChartResult<Song>]) -> (), failure: @escaping (MSError) -> ()) {
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "chartResult", withExtension: "json") else {
            fatalError("Missing repositories.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        
        let dataResponse : Response<[ChartResult<Song>]> = try! JSONDecoder().decode(Response<[ChartResult<Song>]>.self, from: jsonData)
        
        completionHandler(dataResponse.results!)
    }
    
    func search(query: String, storeFront: StoreFront, completionHandler: @escaping (SearchResult<Song>) -> (), failure: @escaping (MSError) -> ()) {
        let bundle = Bundle.main
        
        guard let url = bundle.url(forResource: "searchResult", withExtension: "json") else {
            fatalError("Missing repositories.json")
        }
        
        let jsonData = try! Data(contentsOf: url)
        
        let dataResponse : Response<SearchResult<Song>> = try! JSONDecoder().decode(Response<SearchResult<Song>>.self, from: jsonData)
        
        completionHandler(dataResponse.results!)
    }
}
