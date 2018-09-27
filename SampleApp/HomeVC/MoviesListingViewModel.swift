//
//  MoviesListingViewModel.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation


class MovieCollectionViewCellModel {
    
    var title: String?
    var id: Int?
    var posterPath: String?
    
    
    init(with movieItem: Movie) {
        
        self.title = movieItem.title ?? ""
        self.id = movieItem.id ?? 0
        
        if let imageUrl = movieItem.posterPath {
            
            let fullImageUrl =  kBaseImageURLPath + imageUrl
            self.posterPath = fullImageUrl
        }
        else
        {
            self.posterPath = nil
        }
    }
    
    
}

class MoviesListViewModel {
    
    let apiLoader: APIRequestLoader<MoviesListRequest>
    var movieApiResponse = MoviesListingModel()
    var isUserRefreshingList: Bool = false
    var isLoadingNextPageResults: Bool = false
    
    
    init(_ loader: APIRequestLoader<MoviesListRequest> = APIRequestLoader(apiRequest: MoviesListRequest())) {
        self.apiLoader = loader
    }
    
    func getListViewCellModel(for indexPath: IndexPath) -> MovieCollectionViewCellModel {
        return MovieCollectionViewCellModel(with: self.movieApiResponse.movies[indexPath.item])
    }
    
    func canloadNextPage() -> Bool {
        
        if isUserRefreshingList || isLoadingNextPageResults {
            return false
        }
        
        if let currentPage = movieApiResponse.page, let totalPages = movieApiResponse.numberOfPages, currentPage > 1 + totalPages{
            return false
        }
        return true
    }
    
    func loadMovesList(result: @escaping (Result<String>)->Void)  {
        
        let page = isUserRefreshingList ? 1 : (movieApiResponse.page ?? 0) + 1
        
        
        apiLoader.loadAPIRequest(requestData: "\(page)") { [weak self] (apiResponse, error) in
            
            if let response = apiResponse {
               
                self?.movieApiResponse.addResults(from: response)
                
                result(.Success)
            }
            else{
                result(.failure(error.debugDescription))
            }
            
            
        }
        
    }
    
}
