//
//  DetailsViewController.swift
//  whats_playing
//
//  Created by Sahil Agarwal on 10/16/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        overviewLabel.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            
            let lowResPosterBaseUrl = "http://image.tmdb.org/t/p/w150"
            let lowResPosterUrl = URL(string: lowResPosterBaseUrl + posterPath)
            let lowResImageRequest = URLRequest(url: lowResPosterUrl!)
            
            let highResPosterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let highResPosterUrl = URL(string: highResPosterBaseUrl + posterPath)
            let highResImageRequest = URLRequest(url: highResPosterUrl!)
            
            self.posterImageView.setImageWith(
                lowResImageRequest,
                placeholderImage: nil,
                success: { (lowResImageRequest, lowResImageResponse, lowResImage) -> Void in
                    
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = lowResImage
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.posterImageView.alpha = 1.0
                        }, completion: { (success) -> Void in
                            self.posterImageView.setImageWith(
                                highResImageRequest,
                                placeholderImage: lowResImage,
                                success: { (highResImageRequest, highResImageResponse, highResImage) -> Void in
                                    
                                    self.posterImageView.image = highResImage
                                },
                                failure: { (request, response, error) -> Void in
                                    self.posterImageView.image = nil
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    self.posterImageView.image = nil
            })
        } else {
            self.posterImageView.image = UIImage(named: "no-image")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
