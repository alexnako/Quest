//
//  ResetPasswordViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //emailField.becomeFirstResponder()
        
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
        //Add padding for emailNameField
        let paddingForUserName = UIView(frame: CGRectMake(0, 0, 36, self.emailField.frame.size.height))
        emailField.leftView = paddingForUserName
        emailField.leftViewMode = UITextFieldViewMode .Always
       
        //Textfield UI
        self.emailField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.emailField.textColor = UIColor.whiteColor()
        self.emailField.layer.cornerRadius = 2
        
        
        //resetbutton border
        resetButton.layer.cornerRadius = 2;
        resetButton.layer.borderWidth = 2;
        resetButton.layer.borderColor = UIColor.whiteColor().CGColor

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        // change status bar to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressReset(sender: AnyObject) {

        PFUser.requestPasswordResetForEmailInBackground(emailField.text!.lowercaseString)
    }
    @IBAction func didPressBack(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
