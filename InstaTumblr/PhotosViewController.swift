//
//  ViewController.swift
//  InstaTumblr
//
//  Created by Joshua Escribano on 10/13/16.
//  Copyright © 2016 Joshua and Sahil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary] = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 320
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        loadTumblr()
    }

    func loadTumblr(_ refreshControl: UIRefreshControl? = nil) {
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    self.posts = responseDictionary.value(forKeyPath: "response.posts") as! [NSDictionary]
                    if refreshControl != nil {
                        refreshControl?.endRefreshing()
                    }
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadTumblr(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoPrototypeCell", for: indexPath) as! DemoPrototypeCell
        let photosArrayDict = posts[indexPath.section].value(forKeyPath: "photos") as! [NSDictionary]
        let urlString = (photosArrayDict[0].value(forKey: "original_size") as! NSDictionary).value(forKey: "url") as! String
        let url = URL(string: urlString)
        cell.myImage.setImageWith(url!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // set the avatar
        profileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: 320, height: 50))
        
        let date = posts[section].value(forKeyPath: "date") as? String
        label.text = "\(date!.components(separatedBy: " ")[0])"
    
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsViewController
        var indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        let photosArrayDict = posts[(indexPath?.row)!].value(forKeyPath: "photos") as! [NSDictionary]
        let urlString = (photosArrayDict[0].value(forKey: "original_size") as! NSDictionary).value(forKey: "url") as! String
        vc.photoUrl = urlString
    }
}

