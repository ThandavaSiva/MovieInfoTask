//
//  NetworkManager.swift
//  SampleApp
//
//  Created by admin on 13/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation


let kBaseImageURLPath: String = "https://image.tmdb.org/t/p/w200"

enum Result<String> {
    case Success
    case failure(String)
}

protocol APIRequest {
    
    associatedtype RequestDataType
    associatedtype ResponseDataType

    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
    func shouldCacheResponse() -> Bool
}

extension APIRequest {
    
    func shouldCacheResponse() -> Bool {
        return false
    }
}

class APIRequestLoader<T: APIRequest> {
    
    let apiRequest: T
    let urlSession: URLSession
    var task: URLSessionDataTask?
    
    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    deinit {
        print("deinit : \(apiRequest) ")
    }
    
    func loadAPIRequest(requestData: T.RequestDataType, completionHandler: @escaping(T.ResponseDataType?, Error?)-> Void) {
        
        do {
            let urlRequest = try self.apiRequest.makeRequest(from: requestData)
            
            NetworkLogger.log(request: urlRequest)
            
            if let response = getCachedData(from: urlRequest) {
                completionHandler(response, nil)
                return
            }

            
            task = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                NetworkLogger.log(response: response, data: data, error: error, forRequest: urlRequest)
                
                guard let data = data else  {
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, error)}
                    return
                }
                
                if self.apiRequest.shouldCacheResponse() {
                    
                    self.cacheData(data: data, forRequest: urlRequest)
                }
                
                do {
                    
                   let parsedResponse = try self.apiRequest.parseResponse(data: data)
                    
                    DispatchQueue.main.async {
                        completionHandler(parsedResponse, nil)
                    }
                    
                }catch {
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
                
                
                
            })
            
            task?.resume()
        } catch  {
            print("Unable to create request")
        }
        
    }
    
    func cancelTask()
    {
        self.task?.cancel()
        self.task = nil
    }
    
}


let dataCache = NSCache<NSString, NSData>()

extension APIRequestLoader{
    
    func getCachedData(from request: URLRequest) -> T.ResponseDataType? {
        
        if let key = request.url?.absoluteString, let cachedData = dataCache.object(forKey: key as NSString) {
            return try? self.apiRequest.parseResponse(data: cachedData as Data)
        }
        
        return nil
    }
    
    func cacheData(data: Data, forRequest: URLRequest?) {
        if let key = forRequest?.url?.absoluteString {
            dataCache.setObject(data as NSData, forKey: key as NSString)
        }
    }
}








