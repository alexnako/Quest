//
//  CreateAccountViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // CREATE ACCOUNT
    @IBAction func didCreateAccount(sender: AnyObject) {
        let user = PFUser()
        user.username = userNameField.text
        user.password = passwordField.text
        user.signUpInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            self.performSegueWithIdentifier("createAccountSegue", sender: self)
        }
    }


    // CANCELLING CREATE ACCOUNT
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}