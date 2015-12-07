//
//  HomeViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var totalPlansLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var newPlanButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func testIndex(sender: AnyObject) {
//        self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: 3, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
//        
//        self.collectionView.setContentOffset(CGPoint(x: 213, y: 0), animated: true)
        print("test index")
        
    }
    let currentUser = PFUser.currentUser()
    let reuseIdentifier = "Cell"
    var plans: [PFObject]!
    var planToEdit: String!
    
    var colors = [UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1.0), UIColor(red: 159/255, green: 0/255, blue: 255/255, alpha: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        plans = []
        
        //collectionView.contentOffset.x = 213.5
        
        
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
        // Register NIB
        collectionView!.registerNib(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    
        
    }
    
    override func viewDidAppear(animated: Bool) {
        

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
                
                self.collectionView.setContentOffset(CGPoint(x: 213.5, y: 0), animated: false)
                
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
            return plans.count + 1
    }

    // Create Cell (Plan Cards)
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            if (indexPath.row == 0) {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CircularCollectionViewCell
                cell.title = "Create New"
                let backgroundColor = colors[indexPath.row % colors.count]
                cell.contentView.backgroundColor = backgroundColor
                return cell
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CircularCollectionViewCell
                
                cell.title = plans[indexPath.row-1]["title"] as? String ?? "No Title"
                let backgroundColor = colors[indexPath.row % colors.count]
                cell.contentView.backgroundColor = backgroundColor
                return cell
            }
//            
//            if collectionView.contentOffset < 118 {
//                print("yes")
//            }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        planToEdit = plans[indexPath.row].objectId!
        print("indexpath \(indexPath.row)")
        
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
    
    func scrollViewDidScroll(collectionView: UIScrollView) {
        let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? CircularCollectionViewCell
        
        let cellAlpha = convertValue(collectionView.contentOffset.x, r1Min: 200, r1Max: 118, r2Min: 0, r2Max: 1)
        
        cell!.contentView.alpha = cellAlpha


//        print(cell!.title)
//        print("yes")
//        print(collectionView.contentOffset.x)
        
        if collectionView.contentOffset.x < 118 {
            print ("create new")
            performSegueWithIdentifier("composerSegue", sender: self)
            
            
        }
    }
    
    
    
    

}

