//
//  ViewController.swift
//  testeDafiti
//
//  Created by Marcelo Pavani on 06/08/17.
//  Copyright © 2017 Marcelo Pavani. All rights reserved.
//

import UIKit
import Alamofire

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    @IBOutlet weak var collMovie: UICollectionView!
    
    var trakt = Trakt()
    var movies = [Movie]()
    var searchData = [Movie]()
    var model = [Movie]()
    var fanart = Fanart()
    var activity = customActivity()
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collMovie!.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(HomeController.refreshMovie), for: .valueChanged)
        
        collMovie!.addSubview(refreshControl)
        
        activity.customActivityIndicatory(self.view, startAnimate: true)
        self.getMovies()
        activity.customActivityIndicatory(self.view, startAnimate: false)
    }
    
    func refreshMovie() {
        
        print("refresh")
        self.collMovie?.reloadData()
        refreshControl.endRefreshing()
    }

    func getMovies() {
        
        trakt.requestTrendingMovies { (movies) in
    
            self.movies = movies
            self.collMovie.reloadData()
        }
    }

    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HomeCollectionViewCell
        cell?.layer.borderWidth = 0.5
        cell?.layer.borderColor = UIColor.black.cgColor
        
        let movie = self.movies[indexPath.item]
        cell?.titleMovie.text = movie.title
        
        activity.customActivityIndicatory(self.view, startAnimate: true)
        
        fanart.requestThumbUrl(for: movie, completion: { (bannerUrl) in
        
            cell?.imgMovie.af_setImage(withURL: bannerUrl, placeholderImage: UIImage(named:"placeHolder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: false, completion: nil)
            
            self.activity.customActivityIndicatory(self.view, startAnimate: false)
        })
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetail", sender: indexPath.row)
    }
    
    // MARK: - UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let device = UIDevice.current.model
        
        if (device == "iPad" || device == "iPad Simulator")
        {
            return CGSize(width: (UIScreen.main.bounds.width-15)/3, height: 230)
        }
        
        return CGSize(width: (UIScreen.main.bounds.width-15)/3, height: 170)

    }
    
    func searchMovie(searchText: String)
    {
        for model in (self.movies) {
            if (model.title ?? "").contains(searchText) {
                searchData.append(model)
            }
        }
        
        activity.customActivityIndicatory(self.view, startAnimate: false)
        
        self.movies = searchData
        self.collMovie.reloadData()
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        if(!(searchBar.text?.isEmpty)!){
            self.searchMovie(searchText: searchBar.text!)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = true
        
        if(searchText.isEmpty){
            self.searchMovie(searchText: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = ""
        searchBar.showsCancelButton = false

        self.getMovies()
        self.collMovie.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "movieDetail") {
            
            let vc = segue.destination as! MovieDetailViewController
            vc.movies = [self.movies[sender as! Int]]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


