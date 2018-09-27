//
//  ViewController.swift
//  SampleApp
//
//  Created by admin on 13/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintCollectionViewBottomMargin: NSLayoutConstraint!
    var refreshControl: UIRefreshControl?
    
    
    let modelView = MoviesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doInitialConfiguration()
        //loadMovies()
        
    }
    
    func doInitialConfiguration() {
        self.title = "Movies"
        configureRefershControl(on: collectionView)
    }
    
    
    func loadMovies() {
        
        
        modelView.loadMovesList { [weak self] (result) in
            
            self?.refreshControl?.endRefreshing()
            self?.isLoadingNextPageResults(false)

            switch(result){
            case .Success:
                    print("Success")
                    self?.collectionView.reloadData()
            case .failure(let message):
                    print(message)
            }
        }
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openMovieDetails" {
            
            if  let movieDetailsVC = segue.destination as? MovieDetailsViewController, let cell = sender as? MovieCollectionViewCell{
            
                let model = self.modelView.getListViewCellModel(for: collectionView.indexPath(for: cell)!)
                
                movieDetailsVC.id = model.id
                movieDetailsVC.title = model.title
            
            
            
        }
    }
}
}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelView.movieApiResponse.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MovieCollectionViewCell = collectionView.dequeueCell(atIndexPath: indexPath)
        cell.configureCell(with: self.modelView.getListViewCellModel(for: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-44)/3 , height: (UIScreen.main.bounds.width/3)+20)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        

        guard modelView.canloadNextPage() else {
            return
        }
        let margin: CGFloat = 0
        let heightToLoadNextPage: CGFloat = scrollView.contentSize.height + margin
        let currentPosition: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (currentPosition >= heightToLoadNextPage) {
            isLoadingNextPageResults(true)
            loadMovies()
        }
    }

}

extension ViewController{
    
    func configureRefershControl(on : UICollectionView) {
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refershMovieList), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        collectionView.refreshControl = refreshControl
    }
    
   @objc func refershMovieList() {
    
        modelView.isUserRefreshingList = true
        refreshControl?.beginRefreshing()

        self.loadMovies()
    }
    
}

let kLoaderViewTag = 1011
let kLoaderViewHeight: CGFloat = 50

extension ViewController{
    
    func isLoadingNextPageResults(_ isLoading: Bool) {
        
        self.modelView.isLoadingNextPageResults = isLoading
        
        if isLoading {
            constraintCollectionViewBottomMargin.constant = kLoaderViewHeight
            addLoaderViewForNextResults()
            
        }
        else {
            
            self.constraintCollectionViewBottomMargin.constant = 0
            
            let view = self.view.viewWithTag(kLoaderViewTag)
            view?.removeFromSuperview()
        }
        
        self.view.layoutIfNeeded()
    }
    
    func addLoaderViewForNextResults() {
        let view = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height - kLoaderViewHeight , width: self.view.frame.size.width, height: kLoaderViewHeight))
        view.backgroundColor = UIColor.lightGray
        view.tag = kLoaderViewTag
        
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicatorView.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        indicatorView.startAnimating()
        indicatorView.color = UIColor.white
        indicatorView.isHidden = false
        view.addSubview(indicatorView)
        
        self.view.addSubview(view)
    }
        
    
}








