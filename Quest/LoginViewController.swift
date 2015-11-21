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
    
    func getErrorTitle(error: NSError) -> String {
        var returnString = ""
        
        switch (error.code) {
        case 200:
            returnString = ""
        case 201:
            returnString = ""
        case 125:
            returnString = "Invalid email address"
        default:
            returnString = error.description
        }
        return returnString;
    }
    
    
    func getErrorMessage(error: NSError) -> String {
        var returnString = ""
        
        switch (error.code) {
        case 200:
            returnString = "Oops! Please enter email adrress."
        case 201:
            returnString = "Oops! Please enter password."
        case 125:
            returnString = "Please enter a valid email address."
        default:
            returnString = error.description
        }
        return returnString;
    }
    
    //LOGIN
    @IBAction func didPressLogIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                self.userNameField.text = ""
                self.passwordField.text = ""
                self.performSegueWithIdentifier("logInSegue", sender: self)
            } else {
                let alertController = UIAlertController(title: self.getErrorTitle(error!), message:
                    self.getErrorMessage(error!), preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)

            }
        }
        
    }

    // CANCELLING LOGIN
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
