//
//  MovieCollectionViewCell.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell, CellReusable {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageLoader: APIRequestLoader<ImageRequest>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfig()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageLoader?.cancelTask()

    }
    
    func doInitialConfig() {
        
        self.backgroundColor = UIColor.white
        imageView.backgroundColor = UIColor.lightGray
        
        imageView.makeCornerRadiusWithValue(2.0, borderColor: UIColor.white)
        self.makeCornerRadiusWithValue(2.0, borderColor: UIColor.lightGray)
    }
    
    func configureCell(with model: MovieCollectionViewCellModel) {
        
        guard let imageUrl = model.posterPath else { return }
        
        imageLoader = APIRequestLoader(apiRequest: ImageRequest())
        imageLoader?.loadAPIRequest(requestData: imageUrl, completionHandler: { [weak self] (apiResponse, error) in
            
            if let response = apiResponse{
                self?.imageView.image = response
            }
        })
    }
}
