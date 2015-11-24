//
//  WelcomeViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
<<<<<<< HEAD

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate{
=======
import Parse
import ParseFacebookUtilsV4

class WelcomeViewController: UIViewController {
>>>>>>> master
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in")
            
        }
        else
        {
            print("Logged in")
=======
        /* if (FBSDKAccessToken.currentAccessToken() == nil)
        {
        print("Not logged in")
        
        }
        else
        {
        print("Logged in")
>>>>>>> master
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
<<<<<<< HEAD
        
=======
        */
>>>>>>> master
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Facebook login
<<<<<<< HEAD
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil
        {
        print("Login complete")
            self.performSegueWithIdentifier("facebookLoginSegue", sender: self)
            
        }
        else
        {
        print(error.localizedDescription)
        }
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
    }
=======
    
    @IBAction func didPressFacebookLogin(sender: AnyObject) {
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user:PFUser?, error:NSError?) -> Void in
            if error == nil
            {
                self.performSegueWithIdentifier("facebookLoginSegue", sender: self)
                print("Login complete")
                
            }
            else
            {
                print(error!.localizedDescription)
            }
            
            /*
            PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
            print("Anonymous login failed.")
            } else {
            print("Anonymous user logged in.")
            }
            }
            */
        }
    }
    /*func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    if error == nil
    {
    print("Login complete")
    self.performSegueWithIdentifier("facebookLoginSegue", sender: self)
    
    }
    else
    {
    print(error.localizedDescription)
    }
    
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    
    
    }
    */
>>>>>>> master
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
