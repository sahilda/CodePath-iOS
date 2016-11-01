//
//  ComposeTweetViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    
    var name: String!
    var screenname: String!
    var avatorURL: URL!
    var tweetCharacterCount = 140
    weak var delegate: ComposeTweetDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadNavigationBar()
        nameLabel.text = name
        screennameLabel.text = screenname
        avatorImageView.setImageWith(avatorURL)
        
        loadTextView()
    }
    
    func loadTextView() {
        textView.delegate = self
        textView.text = "Compose your tweet! Touch here."
        textView.becomeFirstResponder()
    }

    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = TwitterBlueColor.getTwitterBlueColor()
        let logo = UIImage(named: "twitter_white_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tweetCharacterCount = textView.text.characters.count
        characterCountLabel.text = "\(140 - tweetCharacterCount)"
    }
    
    @IBAction func tweetButton(_ sender: AnyObject) {
        if(postTweet()) {
            delegate?.sendTweet(sender: self, tweet: textView.text)
        }
    }
    
    func postTweet() -> Bool {
        if (tweetCharacterCount > 140) {
            let alertController = UIAlertController(title: "Error", message: "Tweet is too large - must be 140 characters or less.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            present(alertController, animated: true) { }
            return false
        }
        return true
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}

protocol ComposeTweetDelegate: class {
    func sendTweet(sender: ComposeTweetViewController, tweet: String)
}
