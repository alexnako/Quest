//
//  HomeViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var totalPlansLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var newPlanButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    let currentUser = PFUser.currentUser()
    let reuseIdentifier = "Cell"
    var plans: [PFObject]!
    var planToEdit: String!
    
    /*var colors = [UIColor(red: 126/255, green: 84/255, blue: 201/255, alpha: 1.0), UIColor(red: 36/255, green: 195/255, blue: 221/255, alpha: 1.0), UIColor(red: 237/255, green: 65/255, blue: 89/255, alpha: 1.0), UIColor(red: 3/255, green: 172/255, blue: 253/255, alpha: 1.0), UIColor(red: 42/255, green: 120/255, blue: 254/255, alpha: 1.0), UIColor(red: 252/255, green: 209/255, blue: 65/255, alpha: 1.0)]*/
    /*var colors = [UIColor(red: 238/255, green: 182/255, blue: 67/255, alpha: 1.0), UIColor(red: 230/255, green: 160/255, blue: 65/255, alpha: 1.0), UIColor(red: 218/255, green: 121/255, blue: 60/255, alpha: 1.0), UIColor(red: 111/255, green: 103/255, blue: 190/255, alpha: 1.0), UIColor(red: 91/255, green: 86/255, blue: 167/255, alpha: 1.0), UIColor(red: 65/255, green: 64/255, blue: 144/255, alpha: 1.0)]*/
    var colors = [UIColor(red: 1/255, green: 213/255, blue: 216/255, alpha: 1.0), UIColor(red: 0/255, green: 182/255, blue: 247/255, alpha: 1.0), UIColor(red: 252/255, green: 209/255, blue: 65/255, alpha: 1.0), UIColor(red: 249/255, green: 77/255, blue: 99/255, alpha: 1.0), UIColor(red: 126/255, green: 84/255, blue: 201/255, alpha: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        plans = []
        
        
        //newPlanButton.layer.cornerRadius = 4;
        //newPlanButton.layer.borderWidth = 1;
        //newPlanButton.layer.borderColor = UIColor.blackColor().CGColor
        //logoutButton.layer.cornerRadius = 4;
        //logoutButton.layer.borderWidth = 1;
        //logoutButton.layer.borderColor = UIColor.blackColor().CGColor
        //profilePictureView.layer.borderWidth = 1
        //profilePictureView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        // Set profile image view roundded
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2;
        self.profilePictureView.clipsToBounds = true;
        
        // Display User Name or Profile Picture if from Facebook
        if (PFFacebookUtils.isLinkedWithUser(self.currentUser!)) {
            // User is from Facebook
            self.usernameLabel.hidden = true
            var accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
            let urlRequest = NSURLRequest(URL: url!)
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                
                // Display the image
                let image = UIImage(data: data!)
                self.profilePictureView.image = image
                
            }
        } else {
            self.usernameLabel.hidden = false
        }
        
        // LOADING USER NAME AND NUMBER OF PLANS
        usernameLabel.text = currentUser?.username
        fetchPans()
        
        // REFRESHING LIST
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refresh", object: nil)
        // Register NIB
        collectionView!.registerNib(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    override func viewWillAppear(animated: Bool) {
        
        // change status bar to white
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        super.viewWillAppear(animated)
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
                // Reload cards
                self.collectionView.reloadData()
                
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
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return plans.count
    }
    
    // Create Cell (Plan Cards)
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CircularCollectionViewCell
            
            cell.title = plans[indexPath.row]["title"] as? String ?? "No Title"
            let backgroundColor = colors[indexPath.row % colors.count]
            cell.contentView.backgroundColor = backgroundColor
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        planToEdit = plans[indexPath.row].objectId!
        performSegueWithIdentifier("readerSegue", sender: self)
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
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
}

