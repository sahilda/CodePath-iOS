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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [NSDictionary]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self

        networkRequest()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkRequest(refreshControl: refreshControl)
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
                    NSLog("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.overviewLabel.sizeToFit()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.movie = movie
        
    }

}
