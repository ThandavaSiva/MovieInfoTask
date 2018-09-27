//
//  MovieDetailsViewController.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var id: Int?
    var model = MovieDetailsViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        doInitialConfig()
    }
    
    func doInitialConfig() {
        
        model.loadMovieDetails(for: id!) { [weak self] (result) in
            
            self?.activityIndicator.stopAnimating()

            switch(result){
            case .Success:
                self?.tableView.reloadData()
            case .failure(let message):
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (alert) in self?.navigationController?.popViewController(animated: true) }))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
                    self?.doInitialConfig()
                    self?.activityIndicator.startAnimating()
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.model.apiLoader.cancelTask()
    }
    
    deinit {
        print("Deinit: Movies Details")
    }


}

extension MovieDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cellTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = model.cellTypes[indexPath.row]
        
        switch cellType {
        case .imageAndDescription:
            let cell : HeaderTableViewCell = tableView.dequeueCell(atIndexPath: indexPath)
            cell.configureCell(with: model.getModelForCell(cellType: .imageAndDescription))
            return cell
        case .language:
            let cell: DescriptionTableViewCell = tableView.dequeueCell(atIndexPath: indexPath)
            cell.configureCell(with: model.getModelForCell(cellType: .language))
            return cell
        case .genres:
            let cell: DescriptionTableViewCell = tableView.dequeueCell(atIndexPath: indexPath)
            cell.configureCell(with: model.getModelForCell(cellType: .genres))
            return cell
        case .releaseDate:
            let cell: DescriptionTableViewCell = tableView.dequeueCell(atIndexPath: indexPath)
            cell.configureCell(with: model.getModelForCell(cellType: .releaseDate))
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "dummyCell")! 
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        model.shouldExpandCell = !model.shouldExpandCell
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
