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
    var planToEditColor: UIColor!
    var planToEditTitle: String!
    var scaleTransition: ScaleTransition!
    var expandTransition: ExpandTransition!
    
    @IBOutlet weak var selectedCard: UIView!
    @IBOutlet weak var selectedCardTitle: UITextView!
    
    override func viewDidLoad() {
        selectedCard.hidden = true
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        plans = []
        //fade transition
        scaleTransition = ScaleTransition ()
        scaleTransition.duration = 0.8
        
        expandTransition = ExpandTransition()
        
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
        query.orderByDescending("createdAt")
        
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
            var color = plans[indexPath.row]["color"] as? String
            var colorIndex = Int(color!)
            cell.contentView.backgroundColor = colorSet[colorIndex!]
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        planToEdit = plans[indexPath.row].objectId!
        planToEditTitle = plans[indexPath.row]["title"] as? String
        var color = plans[indexPath.row]["color"] as? String
        var colorIndex = Int(color!)
        planToEditColor = colorSet[colorIndex!]
        performSegueWithIdentifier("readerSegue", sender: self)
    }
    
    
    // PASSING VARIABLE TO PLAN READER – WON'T NEED THIS IF READER IS CALLED FROM DIDSELECT
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "readerSegue") {
            
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! ReaderTableViewController
            
            //calling custom transition
            
            // your new view controller should have property that will store passed value
            viewController.passedValue = planToEdit
            //Scaletransition to reader
            viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            viewController.transitioningDelegate = expandTransition
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }
    
}

