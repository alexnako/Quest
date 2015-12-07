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
import Parse
import ParseFacebookUtilsV4
import VideoSplash

// Use VideoSplash
class WelcomeViewController: VideoSplashViewController {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBOutlet weak var taglineText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("splashvideo3", ofType: "mp4")!)
        
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = false
        // Notice that the startTime and duration need to be set based on actual video.
        self.startTime = 0
        self.duration = 9.64
        self.alpha = 0.6
        self.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        self.contentURL = url
        self.restartForeground = true
        
        //CreateAccount button UI
        createAccountButton.layer.cornerRadius = 2;
        createAccountButton.layer.borderWidth = 2;
        createAccountButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        iconView.alpha = 0
        createAccountButton.alpha = 0
        login.alpha = 0
        facebookIcon.alpha = 0
        facebookLoginButton.alpha = 0
        taglineText.alpha = 0
        // change status bar to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(1.4, delay: 0.0, options: .CurveEaseOut, animations: {
            () -> Void in
            
            self.iconView.alpha = 1
            self.createAccountButton.alpha = 1
            self.login.alpha = 1
            self.facebookIcon.alpha = 1
            self.facebookLoginButton.alpha = 1
            }, completion: { finished in
                UIView.animateWithDuration(0.5, delay: 0.4, options: .CurveEaseOut, animations:  {
                    
                    self.iconView.frame.origin.y -= self.view.frame.size.height * 0.33
                    }, completion: { finished2 in  UIView.animateWithDuration(0.6, animations:  {
                        
                        self.taglineText.alpha = 1
                        })
                    }
                )
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Facebook login
    
    @IBAction func didPressFacebookLogin(sender: AnyObject) {
        let permissions = ["public_profile", "email"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user:PFUser?, error:NSError?) -> Void in
            if (error == nil && user != nil)
            {
                self.performSegueWithIdentifier("facebookLoginSegue", sender: self)
                print("Login complete")
                
            }
            else
            {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
}
