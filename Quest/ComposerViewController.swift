//
//  ComposerViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class ComposerViewController: UIViewController {
    
    @IBOutlet weak var titlePlanField: UITextField!
    @IBOutlet weak var tagsPlanField: UITextField!
    @IBOutlet weak var bodyPlanField: UITextField!
    @IBOutlet weak var totalPlansLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPans()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func didPressCreate(sender: AnyObject) {
        
//        let user = PFUser.currentUser()
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
        plan["user"] = "testuser"
        plan["tags"] = tags
        plan["body"] = bodyPlanField.text
    
        // SAVING PLAN
        plan.saveInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            if error == nil {
                // print("create success")
                self.fetchPans()
                self.titlePlanField.text = ""
                self.tagsPlanField.text = ""
                self.bodyPlanField.text = ""
                
            } else {
                print("error\(error)")
            }
        }
    
        
    }
    
    // FETCHING NUMBER OF PLANS FROM USER. THIS HAS TESTUSER HARDCODED BUT WE NEED TO CHANGE TO CURRENT USER ONCE EVERYTHING IS CONNECTED. THIS IS A TEST FUNCTION IN THIS SCREEN, WE NEED TO MOVE IT TO THE MAIN LIST VIEW
    func fetchPans() {
        
        let query = PFQuery(className:"Plan")
        query.whereKey("user", equalTo:"testuser")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) plans")
                self.totalPlansLabel.text = String(objects!.count)
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
        
        
    }
    
    
}



