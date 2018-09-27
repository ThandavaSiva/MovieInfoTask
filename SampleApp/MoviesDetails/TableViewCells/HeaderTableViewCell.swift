//
//  HeaderTableViewCell.swift
//  SampleApp
//
//  Created by admin on 16/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell, CellReusable {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var lblShowFull: UILabel!

    var imageApi : APIRequestLoader<ImageRequest>?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func configureCell(with model: MovieDetailsCellModel?) {
        
        if let model = model as? HeaderCellModel {
        
        
        self.titleLabel.text = model.title ?? ""
        self.popularityLabel.text = model.popularity ?? ""
        self.durationLabel.text = model.duration ?? ""
        self.overviewLabel.text = model.overview ?? ""
            
            
            if let desc = model.overview {
                
                switch model.cellHeight {
                case .expended:
                    overviewLabel.text = desc
                    lblShowFull.text = "Show less"
                    
                case .collapsed:
                    
                    overviewLabel.text = String(desc.prefix(150))
                    //str[str.index(after: str.index(str.startIndex, offsetBy: 4))]
                    
                    lblShowFull.text = "Show full.."
                case .noraml:
                    lblShowFull.text = ""
                    overviewLabel.text = desc
                    
                    
                }
            }
            
        self.imageApi = APIRequestLoader(apiRequest: ImageRequest())
        
        if let imageUrl = model.posterPath {
            
            imageApi?.loadAPIRequest(requestData: imageUrl, completionHandler: { [weak self] (apiResponse, error) in
                
                if let image = apiResponse{
                    self?.imgView.image = image
                }
                
            })
        }
        
    }
    }

    
}
