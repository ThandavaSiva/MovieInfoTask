//
//  MovieDetailsViewModel.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

enum MovieDetailsCellTypes{
    case imageAndDescription, language, genres, releaseDate, endDummyCell
}

enum CellHeight{
    case expended, collapsed, noraml
}


protocol MovieDetailsCellModel {
    
}

struct HeaderCellModel: MovieDetailsCellModel {
    var title: String?
    var posterPath: String?
    var popularity: String?
    var duration: String?
    var overview: String?
    var cellHeight: CellHeight = .noraml
    
    init(with moviesItem: MoviesDetailsModel, with cellHeight: CellHeight) {
        
        if let title = moviesItem.title {
            self.title = title
        }
        
        if let posterPath = moviesItem.posterPath {
            self.posterPath = kBaseImageURLPath + posterPath
        }
        
        if let popularity = moviesItem.popularity {
            self.popularity = "Popularity: " + String(format: "%.2f", popularity)
        }
        
        if let duration = moviesItem.duration {
            self.duration = "Duration: \(duration / 60)Hrs : \(duration % 60)Mins"
        }
        if let overView = moviesItem.overview {
            self.overview = overView
            
            if overView.count > 200{
                self.cellHeight = cellHeight
            }
        }
    }
    
    
}


struct DescriptionCellModel: MovieDetailsCellModel {
    var header: String?
    var description: String?
    
    
}

class MovieDetailsViewModel {
    
    var apiLoader: APIRequestLoader<MovieDetailsRequest>
    var model: MoviesDetailsModel?
    var cellTypes = Array<MovieDetailsCellTypes>()
    var shouldExpandCell: Bool = false
    
    
    init(loader: APIRequestLoader<MovieDetailsRequest> = APIRequestLoader(apiRequest: MovieDetailsRequest())) {
        
        self.apiLoader = loader
    }
    
    func getModelForCell(cellType: MovieDetailsCellTypes) -> MovieDetailsCellModel {
        
        switch cellType {
            
        case .imageAndDescription:
            return HeaderCellModel(with: model!, with: self.shouldExpandCell ? .expended : .collapsed)
        
        case .genres:
           let genres = model?.genres.map({ (genres) -> String in
                return genres.name!
            }).joined(separator: ",")
            return DescriptionCellModel(header: "Genres", description: genres)
        
        case .language:
            let laguages = model?.languages.map({ (laguage) -> String in
                return laguage.name!
            }).joined(separator: ",")
            return DescriptionCellModel(header: "Laguages", description: laguages)
        
        case .releaseDate:
            return DescriptionCellModel(header: "Release Date", description: model?.releaseDate)
            
        default:
            return DescriptionCellModel(header: "", description: "")
            
        }
    
        
    }
    
    func loadMovieDetails(for movieId: Int, result: @escaping(Result<String>)->Void) {
        
        self.apiLoader.loadAPIRequest(requestData: movieId) { [weak self](apiResponse, error) in
            
            
            guard let weakSelf = self else {
                result(.failure(error.debugDescription))
                return
            }
            
           if let response = apiResponse{
            
            
            weakSelf.model = apiResponse
            weakSelf.cellTypes = weakSelf.getCellTypes(from: response)
            result(.Success)

            }
            else
           {
            
            if let message = error?.localizedDescription{
                
                result(.failure(message))

            }
            
            
            }
            
        }
    }
    
    func getCellTypes(from movieDetails: MoviesDetailsModel) -> Array<MovieDetailsCellTypes> {
        
        var cellTypeArray = Array<MovieDetailsCellTypes>()
        
        cellTypeArray.append(.imageAndDescription)
        
        if let _ = movieDetails.releaseDate {
            
            cellTypeArray.append(.releaseDate)
        }
        
        if movieDetails.genres.count > 0 {
            
            cellTypeArray.append(.genres)
        }
        
        if movieDetails.languages.count > 0
        {
            cellTypeArray.append(.language)
        }
        
        cellTypeArray.append(.endDummyCell)
        
        return cellTypeArray
        
    }
    
    deinit {
        print("Deinit: MovieDetailsViewModel")
    }
    
}
