//
//  ReaderViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/24/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class ReaderViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var titleField: UITextView!
    @IBOutlet weak var tagsPlanField: UITextField!
    @IBOutlet weak var bodyPlanField: UITextView!
    @IBOutlet weak var titlePlaceholder: UILabel!
    @IBOutlet weak var bodyPlaceholderLabel: UILabel!
    
    @IBOutlet weak var titleFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var bodyPlanHeight: NSLayoutConstraint!
    
    
    let currentUser = PFUser.currentUser()
    var plan: PFObject!
    var passedValue: String!
    
    @IBOutlet weak var titlePlanField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(passedValue)
        
        bodyPlanField.delegate = self
        titleField.delegate = self
        
        fetchPlan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // FETCHING PLAN
    func fetchPlan() {
        
        let query = PFQuery(className:"Plan")
        query.whereKey("user", equalTo: (currentUser?.username)!)
        query.getObjectInBackgroundWithId(passedValue) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else {
                //print(object)
                self.plan = object
                self.titleField.text = self.plan!["title"] as? String
                

                let nsArray = self.plan!["tags"]
                let swiftArray = nsArray as AnyObject as! [String]
                let tagsString = swiftArray.joinWithSeparator(", ")
                
                let tags = tagsString
                self.tagsPlanField.text = String(tags)
                self.bodyPlanField.text = self.plan!["body"] as? String
            }
        }
    }

    
    // CHANGE SIZE OF PLAN ACCORDING TO TEXT SIZE
    func textViewDidChangeSelection(textView: UITextView) {
        
        // TITLE
        if textView == titleField {
            titleField.sizeToFit()
            titleField.layoutIfNeeded()
            let height = titleField.sizeThatFits(CGSizeMake(titleField.frame.size.width, CGFloat.max)).height
            if height > 120 {
                titleFieldHeight.constant = height
            }
            if !self.titleField.text!.isEmpty {
                titlePlaceholder.hidden = true
                
            } else {
                titlePlaceholder.hidden = false
                
            }
            
            // BODY
        } else if textView == bodyPlanField {
            bodyPlanField.sizeToFit()
            bodyPlanField.layoutIfNeeded()
            let height = bodyPlanField.sizeThatFits(CGSizeMake(bodyPlanField.frame.size.width, CGFloat.max)).height
            if height > 60 {
                bodyPlanHeight.constant = height
            }
            
            if !self.bodyPlanField.text!.isEmpty {
                bodyPlaceholderLabel.hidden = true
            } else {
                bodyPlaceholderLabel.hidden = false
            }
        }
        
    }
    
    
    
    // SAVING
    func savePlan() {
        
        let query = PFQuery(className:"Plan")
        query.whereKey("user", equalTo: (currentUser?.username)!)
        query.getObjectInBackgroundWithId(passedValue) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else {
                
                //CONVERTING TAG STRING INTO ARRAY
                var tags = []
                if !self.tagsPlanField.text!.isEmpty {
                    tags = self.tagsPlanField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
                    //print(tags)
                    tags = tags.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
                    //print(tags.count)
                }
                
                
                
                object?["title"] = self.titleField.text
                object?["tags"] = tags
                object?["body"] = self.bodyPlanField.text
                object?.saveInBackground()
            }
        }
    }
    
    
    // BACK TO PLAN LIST
    @IBAction func didPressBack(sender: AnyObject) {
        
        if titleField.text == "" {
            
            let alertController = UIAlertController(title: "Discard Plan", message: "You haven't added a title to your plan. Do you want to delete this plan?", preferredStyle: .Alert)
            
            // Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            alertController.addAction(cancelAction)
            
            // DELETE PLAN WITHOUT TITLE
            let OKAction = UIAlertAction(title: "Discard", style: .Default) { (action) in
                
                let query = PFQuery(className:"Plan")
                query.whereKey("user", equalTo: (self.currentUser?.username)!)
                query.getObjectInBackgroundWithId(self.passedValue) { (obj, err) -> Void in
                    if err != nil {
                        //handle error
                    } else {
                        obj!.deleteInBackground()
                    }
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
            }
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true) { }
            
        } else {
            savePlan()
            self.dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        }
        
    }

}
