//
//  ReaderViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/24/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class ReaderViewController: UIViewController {

    
    let currentUser = PFUser.currentUser()
    var plan: PFObject!
    var passedValue: String!
    
    @IBOutlet weak var titlePlanField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedValue)
        
        fetchPlan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressPrint(sender: AnyObject) {
        savePlan()
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
                self.titlePlanField.text = self.plan!["title"] as? String
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
                object?["title"] = self.titlePlanField.text
                object?.saveInBackground()
            }
        }
    }
    
    
    @IBAction func didPressBack(sender: AnyObject) {
        
        savePlan()
        self.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }

}
