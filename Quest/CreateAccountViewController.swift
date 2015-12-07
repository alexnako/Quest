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
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //auto pop-up keyboard
        //userNameField.becomeFirstResponder()
        
        //Add blur effect background
        let backgroundImageView = UIImageView(image: UIImage(named: "createaccountbackground"))
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .ScaleAspectFill
        view.addSubview(backgroundImageView)
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = backgroundImageView.bounds
        view.addSubview(blurredEffectView)
        
        // Send background image view to the back in correct order
        view.sendSubviewToBack(blurredEffectView)
        view.sendSubviewToBack(backgroundImageView)
        
        //Add padding for userNameField
        let paddingForUserName = UIView(frame: CGRectMake(0, 0, 36, self.userNameField.frame.size.height))
        userNameField.leftView = paddingForUserName
        userNameField.leftViewMode = UITextFieldViewMode .Always
        
        //Add padding for passwordField
        let paddingForPassword = UIView(frame: CGRectMake(0, 0, 36, self.passwordField.frame.size.height))
        passwordField.leftView = paddingForPassword
        passwordField.leftViewMode = UITextFieldViewMode .Always
        
        
        //Textfield UI
        self.userNameField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.passwordField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.userNameField.textColor = UIColor.whiteColor()
        self.passwordField.textColor = UIColor.whiteColor()
        self.userNameField.layer.cornerRadius = 2
        self.passwordField.layer.cornerRadius = 2
        
        // createAccount button border
        createAccountButton.layer.cornerRadius = 2;
        createAccountButton.layer.borderWidth = 2;
        createAccountButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        // change status bar to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
    }
    override func viewWillAppear(animated: Bool) {
        
        // change status bar to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        super.viewWillAppear(animated)
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
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
}