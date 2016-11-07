//
//  ComposeTweetViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    
    var user: User!
    var startingText: String?
    var reply_id: Int? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        loadData()
        loadTextView()
    }
    
    func loadData() {
        nameLabel.text = user.name!
        screennameLabel.text = "@\(user.screenname!)"
        avatorImageView.setImageWith(user.profileURL!)
        if startingText != nil {
            textView.text = startingText
        } else {
            textView.text = nil
        }
        characterCountLabel.text = "\(140 - textView.text.characters.count)"
    }
    
    func loadTextView() {
        textView.delegate = self
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
    
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text = "\(140 - textView.text.characters.count)"
    }
    
    @IBAction func tweetButton(_ sender: AnyObject) {
        if(validTweet()) {
            postTweet(tweet: textView.text)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func validTweet() -> Bool {
        if (textView.text.characters.count > 140) {
            let alertController = UIAlertController(title: "Error", message: "Tweet is too large - must be 140 characters or less.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            present(alertController, animated: true) { }
            return false
        }
        return true
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func postTweet(tweet: String) {
        TwitterClient.sharedInstance?.postStatus(tweet: tweet, reply_id: reply_id, success: { (tweet: Tweet) -> () in
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
        })
    }

}
