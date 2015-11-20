//
//  LoginViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //LOGIN
    @IBAction func didPressLogIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                self.userNameField.text = ""
                self.passwordField.text = ""
                self.performSegueWithIdentifier("logInSegue", sender: self)
            } else {
                print("error\(error)")
            }
        }
        
    }

    // CANCELLING LOGIN
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
