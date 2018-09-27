//
//  MoviesListingModel.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct MoviesListingModel: Decodable {
    
    var page: Int? = 0
    var numberOfPages: Int? = 0
    var numberOfResults: Int? = 0
    var movies: [Movie] = []
    
   mutating func addResults(from newObject: MoviesListingModel) {
        
        if let newPage = newObject.page {
            
            self.page = newPage
            self.numberOfPages = newObject.numberOfPages
            self.numberOfResults = newObject.numberOfResults
            self.movies.append(contentsOf: newObject.movies)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case page
        case numberOfPages = "total_pages"
        case numberOfResults = "total_results"
        case movies = "results"
        
    }
}


struct Movie: Decodable {
    
    var id: Int?
    var posterPath: String?
    var title: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overView: String?
    var rating: Double?
    var releaseDate: String?
    var popularity: Double?
    var voteCount: Int?
    var hasVideo: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overView = "overview"
        case rating = "vote_average"
        case releaseDate = "release_date"
        case popularity
        case voteCount = "vote_count"
        case hasVideo = "video"



    }
    
    
}
