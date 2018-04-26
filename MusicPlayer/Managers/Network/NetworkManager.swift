//
//  NetworkManager.swift
//  The Grid
//
//  Created by Anonymous
//

import UIKit

// This protocol will allow to mock the network layer when unit test the project
protocol NetworkRessource {
    func getTopCharts(storeFront: StoreFront, completionHandler: @escaping ([ChartResult<Song>])->(), failure: @escaping (MSError)->())
    func search(query: String, storeFront: StoreFront, completionHandler: @escaping (SearchResult<Song>)->(), failure: @escaping (MSError)->())
}

public typealias FailureHandler = (MSError)->(Void)

struct NetworkManager {
    
    public static let `default` = NetworkManager()
    
    // MARK: Methods
    
    init() { }
    
    @discardableResult
    public func callRequest<T: Codable>(request: URLRequest, withSuccess success: @escaping (Response<T>)->Void, andFailure failure: @escaping FailureHandler) -> URLSessionDataTask {
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let customError = MSError.error(error)
                DispatchQueue.main.async {
                    failure(customError)
                }
            } else {
                
                let response = response as! HTTPURLResponse
                if response.isStatusOK {
                    let decoder = JSONDecoder()
                    if let data = data {
                        let decodedObject = try! decoder.decode(Response<T>.self, from: data)
                        DispatchQueue.main.async {
                            success(decodedObject)
                        }
                    } else {
                        let error = MSError.message(title: "ERROR_ALERT_TITLE".localized, message: "ERROR_DECODE".localized)
                        DispatchQueue.main.async {
                            failure(error)
                        }
                    }
                } else {
                    let error = MSError.httpUrlResponse(response: response)
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}

extension NetworkManager : NetworkRessource {
    
    func getTopCharts(storeFront: StoreFront, completionHandler: @escaping ([ChartResult<Song>]) -> (), failure: @escaping (MSError) -> ()) {
        
        let request = Router.getTopChartSongs(storeFront,
                                              limit: 50).asURLRequest()
        
        self.callRequest(request: request, withSuccess: { (response: Response<[ChartResult<Song>]>)->() in
            if let responseError = response.errors?.first {
                let err = MSError.responseError(responseError)
                failure(err)
            } else if let results = response.results {
                completionHandler(results)
            } else {
                let error = MSError.message(title: "ERROR_ALERT_TITLE".localized, message: "ERROR_NO_RESULTS".localized)
                failure(error)
            }
        }, andFailure: failure)
    }
    
    func search(query: String, storeFront: StoreFront, completionHandler: @escaping (SearchResult<Song>) -> (), failure: @escaping (MSError) -> ()) {
        
        let request = Router.search(storeFront: storeFront,
                                    query: query,
                                    limit: 10).asURLRequest()
        
        self.callRequest(request: request, withSuccess: { (response: Response<SearchResult<Song>>)->() in
            if let responseError = response.errors?.first {
                let err = MSError.responseError(responseError)
                failure(err)
            } else if let results = response.results {
                completionHandler(results)
            } else {
                let error = MSError.message(title: "ERROR_ALERT_TITLE".localized, message: "ERROR_NO_RESULTS".localized)
                failure(error)
            }
        }, andFailure: failure)
    }
}
