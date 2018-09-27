//
//  MovieDetailsModel.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct MoviesDetailsModel: Codable {
    
    var id: Int?
    var posterPath: String?
    var title: String?
    var genres: [Genres] = []
    var popularity: Double?
    var rating: Double?
    var languages: [Languages] = []
    var releaseDate: String?
    var duration: Int?
    var overview: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case genres
        case popularity
        case rating = "vote_average"
        case languages = "spoken_languages"
        case releaseDate = "release_date"
        case duration = "runtime"
        case overview
    }
    
    
}

struct Genres:Codable {
    
    var id: Int?
    var name: String?
}

struct Languages: Codable {
    var name: String?
    
}
