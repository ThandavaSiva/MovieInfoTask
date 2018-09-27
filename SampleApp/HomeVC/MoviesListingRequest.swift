//
//  MoviesListingRequest.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class MoviesListRequest: APIRequest {
    
    
    func makeRequest(from pageNumber: String) throws -> URLRequest {
        
        let params: [String: String] = ["page": pageNumber, "api_key": "7a312711d0d45c9da658b9206f3851dd"]
        let url = try? URLEncoder().urlWith(urlString: "https://api.themoviedb.org/3/discover/movie", parameters: params)
        let urlRequest = URLRequest(url: url!)
        
        return urlRequest
        
        
    }
    
    func parseResponse(data: Data) throws -> MoviesListingModel {
        
        return try JSONDecoder().decode(MoviesListingModel.self, from: data)
        
    }
    
}

class ImageRequest: APIRequest {
    
    func makeRequest(from imagePath: String) throws -> URLRequest {
        
        let urlRequest = URLRequest(url: URL(string: imagePath)!)
        return urlRequest
        
    }
    
    func parseResponse(data: Data) throws -> UIImage {
        
        return UIImage(data: data) ?? UIImage()
    }
    
    func shouldCacheResponse() -> Bool {
        return true
    }
}
