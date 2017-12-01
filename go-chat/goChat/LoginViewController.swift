//
//  ViewController.swift
//  goChat
//
//  Created by Sahil Agarwal on 10/27/16.
//
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        signUp()
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        logIn()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func signUp() {
        let user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                let errorString = error.localizedDescription
                let alertController = UIAlertController(title: "Sign Up Error", message: errorString, preferredStyle: .alert)
                self.present(alertController, animated: true) {
                    sleep(2)
                    alertController.dismiss(animated: true, completion: nil)
                }
            } else {
                self.logIn()
                print("success!")
            }
        }
    }
    
    func logIn() {
        do {
            try PFUser.logIn(withUsername: self.emailTextField.text!, password: self.passwordTextField.text!)
            print("successful log in")
            performSegue(withIdentifier: "loginSuccess", sender: nil)
            
            
        } catch {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Try again", preferredStyle: .alert)
            self.present(alertController, animated: true) {
                sleep(2)
                alertController.dismiss(animated: true, completion: nil)
        }
        }}

}
