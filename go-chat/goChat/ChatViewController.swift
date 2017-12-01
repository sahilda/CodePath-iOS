//
//  ChatViewController.swift
//  goChat
//
//  Created by Sahil Agarwal on 10/27/16.
//
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var allMessages : [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let message = PFObject(className:"MessageSF")
        message["user"] = PFUser.current();
        message["text"] = messageField.text!
        message.saveInBackground { (success, error) in
            if (success) {
                NSLog("Message saved: \(message["text"])")
            } else {
                NSLog("Failed")
            }
        }
        messageField.text = ""
    }
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        let query = PFQuery(className:"MessageSF")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                if let objects = objects {
                    self.allMessages = [String()]
                    for object in objects {
                        if object["text"] != nil {
                            var message = object["text"] as! String
                            if object["user"] != nil {
                                let user = object["user"] as! PFUser
                                message = "\(user.username!): \(object["text"] as! String)"
                            }
                            self.allMessages.append(message)
                            print(object.objectId)

                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.chatLabel.text = allMessages[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
