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
    @IBOutlet weak var loginButton: UIButton!
    var fadeTransition: FadeTransition!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auto popup keyboard
        //userNameField.becomeFirstResponder()
        
        
        //Add blur effect background
        let backgroundImageView = UIImageView(image: UIImage(named: "loginbackground"))
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
        
        
        //Loginbutton border
        loginButton.layer.cornerRadius = 2;
        loginButton.layer.borderWidth = 2;
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //fade transition
        fadeTransition = FadeTransition ()
        fadeTransition.duration = 0.8
        
        
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
        case 101:
            returnString = "Oops! Invalid LogIn"
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
        case 101:
            returnString = "The email, user name or password entered do not match our records."
        default:
            returnString = error.description
        }
        return returnString;
    }
    
    //LOGIN
    @IBAction func didPressLogIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameField.text!.lowercaseString, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                self.userNameField.text = ""
                self.passwordField.text = ""
                self.performSegueWithIdentifier("logIn2Segue", sender: self)
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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    //Transition to Login
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "loginSegue" {
            let destinationViewController = segue.destinationViewController as! HomeViewController
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            destinationViewController.transitioningDelegate = fadeTransition
        } else if segue.identifier == "resetPasswordSegue" {
            let destinationViewController = segue.destinationViewController as! ResetPasswordViewController
            destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            destinationViewController.transitioningDelegate = fadeTransition
        }
        }
}
