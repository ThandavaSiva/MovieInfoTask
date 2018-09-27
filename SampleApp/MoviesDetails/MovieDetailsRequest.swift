//
//  MovieDetailsRequest.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class MovieDetailsRequest: APIRequest {
    
    func makeRequest(from movieId: Int) throws -> URLRequest {
        
        let requestParameter: [String: String] = ["api_key":"7a312711d0d45c9da658b9206f3851dd"]
        let url = try URLEncoder().urlWith(urlString: "https://api.themoviedb.org/3/movie/\(movieId)", parameters: requestParameter)
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        return request
    }
    
    func parseResponse(data: Data) throws -> MoviesDetailsModel {
        
        return try JSONDecoder().decode(MoviesDetailsModel.self, from: data)
    }
}
