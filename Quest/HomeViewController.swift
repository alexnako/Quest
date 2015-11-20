//
//  HomeViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var totalPlansLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    let currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LOADING USER NAME AND NUMBER OF PLANS
        usernameLabel.text = currentUser?.username
        fetchPans()

        // REFRESHING LIST
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refresh", object: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    

    // FETCHING NUMBER OF PLANS FROM USER
    func fetchPans() {
        
        let query = PFQuery(className:"Plan")
        
        query.whereKey("user", equalTo: (currentUser?.username)!)
        print(String(PFUser.currentUser()?.username))
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
    
    // LOGOUT
    @IBAction func didPressLogout(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // REFRESH LIST OF PLANS AFTER CREATING NEW ONE
    func refreshList(notification: NSNotification){
        fetchPans()
    }

}
