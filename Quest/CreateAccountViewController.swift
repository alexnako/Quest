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
        userNameField.becomeFirstResponder()
        
        
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
        case 202:
            returnString = ""
        case 203:
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
        case 202:
            returnString = "The email you entered has already been used. Please LogIn instead."
        case 203:
            returnString = "The user name you entered has already been used. Please LogIn instead."
        case 125:
            returnString = "Please enter a valid email address."

     
        default:
            returnString = error.description
        }
        return returnString;
    }
    
    // CREATE ACCOUNT
    @IBAction func didCreateAccount(sender: AnyObject) {
        let user = PFUser()
        user.username = userNameField.text?.lowercaseString
        user.password = passwordField.text
        user.email = userNameField.text
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if (succeeded) {
                // Successfully created account
                self.performSegueWithIdentifier("createAccountSegue", sender: self)
            } else {
                
                // Parse.com returns error
                let alertController = UIAlertController(title: self.getErrorTitle(error!), message:
                    self.getErrorMessage(error!), preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // CANCELLING CREATE ACCOUNT
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}