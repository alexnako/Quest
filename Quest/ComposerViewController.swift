//
//  ComposerViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class ComposerViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titlePlanField: UITextField!
    @IBOutlet weak var tagsPlanField: UITextField!
    @IBOutlet weak var freetextPlanField: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var bodyPlanField: UITextView!
    @IBOutlet weak var bodyPlaceholderLabel: UILabel!
    
    
    @IBOutlet weak var bodyPlanHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 4;
        createButton.layer.borderWidth = 1;
        createButton.layer.borderColor = UIColor.blackColor().CGColor        
        
        bodyPlanField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // CHANGE SIZE OF PLAN ACCORDING TO TEXT SIZE
    func textViewDidChange(bodyPlanField: UITextView) {
        bodyPlanField.sizeToFit()
        bodyPlanField.layoutIfNeeded()
        let height = bodyPlanField.sizeThatFits(CGSizeMake(bodyPlanField.frame.size.width, CGFloat.max)).height
        if height > 60 {
            bodyPlanHeight.constant = height
        }
        if self.bodyPlanField.text != nil {
            bodyPlaceholderLabel.hidden = true
        } else {
            bodyPlaceholderLabel.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "segueSearch") {
            var svc = segue!.destinationViewController as! SearchViewController;
            
            svc.toPass = tagsPlanField.text
            
        }
    }
    
    
    // CREATING PLAN
    @IBAction func didPressCreate(sender: AnyObject) {
        
        let plan = PFObject(className: "Plan")

        
        //CONVERTING TAG STRING INTO ARRAY
        var tags = []
            if !tagsPlanField.text!.isEmpty {
                tags = tagsPlanField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
                print(tags)
                tags = tags.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
                print(tags.count)
            }
    
        plan["title"] = titlePlanField.text
        plan["user"] = PFUser.currentUser()?.username
        plan["tags"] = tags
        plan["body"] = bodyPlanField.text
    
        // SAVING PLAN
        plan.saveInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            if error == nil {
                // print("create success")
                self.titlePlanField.text = ""
                self.tagsPlanField.text = ""
                self.bodyPlanField.text = ""
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                
            } else {
                print("error\(error)")
            }
        }
    
        
    }
    
    // CANCELLING PLAN CREATION
    
    
    @IBAction func didPressCancel(sender: AnyObject) {
        
        if titlePlanField.text != "" || bodyPlanField.text != "" || tagsPlanField.text != "" {
        
            let alertController = UIAlertController(title: "Discard Plan", message: "Are you sure you want to discard this plan?", preferredStyle: .Alert)
            
            // Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            alertController.addAction(cancelAction)
            
            // OK action
            let OKAction = UIAlertAction(title: "Discard", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            presentViewController(alertController, animated: true) { }
            
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
    }
    
}



