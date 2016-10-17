//
//  MoviesViewController.swift
//  whats_playing
//
//  Created by Sahil Agarwal on 10/13/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint: String!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(red: 178/255, green: 61/255, blue: 47/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // search bar setup
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        navigationItem.titleView = self.searchBar
        
        // segment controller setup
        if(segmentControl.selectedSegmentIndex == 0) {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
        
        // collection view setup
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.insertSubview(refreshControl, at: 0)
    
        // table view setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 178/255, green: 61/255, blue: 47/255, alpha: 1)
        tableView.backgroundView?.backgroundColor = UIColor(red: 178/255, green: 61/255, blue: 47/255, alpha: 1)
        tableView.insertSubview(refreshControl, at: 0)
    
        // data population call
        networkRequest()
    }
    
    @IBAction func segmentControlChange(_ sender: AnyObject) {
        if(segmentControl.selectedSegmentIndex == 0) {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func networkRequest(refreshControl: UIRefreshControl? = nil) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = dataOrNil {
                self.networkErrorView.isHidden = true
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    if refreshControl != nil {
                        refreshControl?.endRefreshing()
                    }
                }
            } else {
                self.networkErrorView.isHidden = false
                self.networkErrorView.frame.size = CGSize(width: self.tableView.frame.width, height: 35)
            }
        });
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies?.filter({(dataItem: NSDictionary) -> Bool in
                if (dataItem["title"] as! String).range(of: searchText) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getRowCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        
        cell.titleLabel.text = ""
        
        if let posterPath = movie["poster_path"] as? String {
            let lowResPosterBaseUrl = "http://image.tmdb.org/t/p/w150"
            let lowResPosterUrl = URL(string: lowResPosterBaseUrl + posterPath)
            let lowResImageRequest = URLRequest(url: lowResPosterUrl!)
            
            let highResPosterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let highResPosterUrl = URL(string: highResPosterBaseUrl + posterPath)
            let highResImageRequest = URLRequest(url: highResPosterUrl!)
            
            cell.posterView.setImageWith(
                lowResImageRequest,
                placeholderImage: nil,
                success: { (lowResImageRequest, lowResImageResponse, lowResImage) -> Void in
                    
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = lowResImage
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                        }, completion: { (success) -> Void in
                            cell.posterView.setImageWith(
                                highResImageRequest,
                                placeholderImage: lowResImage,
                                success: { (highResImageRequest, highResImageResponse, highResImage) -> Void in
                                    
                                    cell.posterView.image = highResImage
                                },
                                failure: { (request, response, error) -> Void in
                                    cell.posterView.image = nil
                                    cell.titleLabel.text = title
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    cell.posterView.image = nil
                    cell.titleLabel.text = title
            })
        } else {
            cell.posterView.image = UIImage(named: "no-image")
            cell.titleLabel.text = title
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.overviewLabel.sizeToFit()
        
        // this block loads the poster image - first a low res, then high res, and also animates it in
        if let posterPath = movie["poster_path"] as? String {
            let lowResPosterBaseUrl = "http://image.tmdb.org/t/p/w150"
            let lowResPosterUrl = URL(string: lowResPosterBaseUrl + posterPath)
            let lowResImageRequest = URLRequest(url: lowResPosterUrl!)
            
            let highResPosterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let highResPosterUrl = URL(string: highResPosterBaseUrl + posterPath)
            let highResImageRequest = URLRequest(url: highResPosterUrl!)
            
            cell.posterView.setImageWith(
                lowResImageRequest,
                placeholderImage: nil,
                success: { (lowResImageRequest, lowResImageResponse, lowResImage) -> Void in
                    
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = lowResImage
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                        }, completion: { (success) -> Void in
                            cell.posterView.setImageWith(
                                highResImageRequest,
                                placeholderImage: lowResImage,
                                success: { (highResImageRequest, highResImageResponse, highResImage) -> Void in
                                    
                                    cell.posterView.image = highResImage
                                },
                                failure: { (request, response, error) -> Void in
                                    cell.posterView.image = nil
                                })
                        })
                },
                failure: { (request, response, error) -> Void in
                    cell.posterView.image = nil
                })
        } else {
            cell.posterView.image = UIImage(named: "no-image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowCount()
    }
    
    func getRowCount() -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkRequest(refreshControl: refreshControl)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if collectionView.isHidden {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = filteredMovies![indexPath!.row]
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.movie = movie
        } else {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = filteredMovies![indexPath!.row]
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.movie = movie
        }
    }

}
