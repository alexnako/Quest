//
//  HomeViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var totalPlansLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newPlanButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let currentUser = PFUser.currentUser()
    var plans: [PFObject]!
    var planToEdit: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        plans = []
        
        
        newPlanButton.layer.cornerRadius = 4;
        newPlanButton.layer.borderWidth = 1;
        newPlanButton.layer.borderColor = UIColor.blackColor().CGColor
        logoutButton.layer.cornerRadius = 4;
        logoutButton.layer.borderWidth = 1;
        logoutButton.layer.borderColor = UIColor.blackColor().CGColor

        
        
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

        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                //print("Successfully retrieved \(objects!.count) plans")
                
                self.plans = objects
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
        
        
    }
    
    
    //TABLE VIEW WITH PLANS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanCell") as! PlanCell
        
        let plan = plans[indexPath.row]
        
        cell.planTitleLabel.text = plan["title"] as? String ?? "No title"
        
        return cell
    }
    
    
    
    //CLICKING ON A PLAN
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PlanCell
        planToEdit = cell.planTitleLabel.text
        
        performSegueWithIdentifier("readerSegue", sender: self)

        // TODO: TRY CREATING SEGUE IN CODE
//        let indexPath = tableView.indexPathForSelectedRow();
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
//        let storyboard = UIStoryboard(name: "YourStoryBoardFileName", bundle: nil)
//        var viewController = storyboard.instantiateViewControllerWithIdentifier("viewControllerIdentifer") as AnotherViewController
//        viewController.passedValue = currentCell.textLabel.text
//        self.presentViewController(viewContoller, animated: true , completion: nil)
        
        
    }
    
    // PASSING VARIABLE TO PLAN READER – WON'T NEED THIS IF READER IS CALLED FROM DIDSELECT
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "readerSegue") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! ReaderViewController
            // your new view controller should have property that will store passed value
            viewController.passedValue = planToEdit
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
