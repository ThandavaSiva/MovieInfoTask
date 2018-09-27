//
//  NetworkLogger.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class NetworkLogger {
    
    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        logRequestData(from: request)
    }
    
    static func log(response: URLResponse?, data: Data?, error: Error?, forRequest: URLRequest) {
        print("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        logRequestData(from: forRequest)
        print("\n - - - - - - - - - - RESPONSE - - - - - - - - - - \n")
        print(String(describing: data?.toJSONObject()))
    }
    
    //MARK: Private Methods
    private static func logRequestData(from request: URLRequest) {
        
        let urlAsString = request.url?.absoluteString ?? ""
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        var logOutput = """
        HTTP: \(method)\n
        URL: \(urlAsString) \n\n
        """
        
        logOutput += "\n HEADERS:"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        
        logOutput += "\nPOST BODY:"
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
}
