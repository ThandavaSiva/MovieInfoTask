//
//  DescriptionTableViewCell.swift
//  SampleApp
//
//  Created by admin on 16/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell, CellReusable {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with model: MovieDetailsCellModel) {
        
        if let model = model as? DescriptionCellModel {
            
            self.headerLabel.text = model.header ?? ""
            self.descriptionLabel.text = model.description ?? ""
        }
    }
}
