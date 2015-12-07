//
//  ReaderTableViewController.swift
//  Quest
//
//  Created by Alex Nako on 12/7/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class ReaderTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    let currentUser = PFUser.currentUser()
    var plan: PFObject!
    var passedValue: String!
    
    var photosSelection: [String]!
    var photosSelected: [String]!
    var cardColor: UIColor!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosSelected = []
        photosSelection = []
        
        
        view.backgroundColor = defaultCardColour
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        backButton.tintColor = UIColor.whiteColor()
        fetchPlan()
    }
    
    
    // NUMBER OF ROWS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + Int(ceil(CGFloat(photosSelection.count)/2))
    }
    
    // CREATING CELLS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! TitleCell
            cell.titlePlanField.becomeFirstResponder()
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TagCell", forIndexPath: indexPath) as! TagCell
            return cell
        } else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("BodyCell", forIndexPath: indexPath) as! BodyCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
            let index = indexPath.row - 3
            if !photosSelection.isEmpty {
                
                let dimension = cell.imageFrame1.frame.width
                
                let imageView1: UIImageView = UIImageView(frame:CGRectMake(0, 0, dimension, dimension))
                imageView1.setImageWithURL(NSURL(string:photosSelection[index*2])!)
                cell.imageFrame1.addSubview(imageView1)
                cell.imageFrame1.clipsToBounds = true
                imageView1.transform = CGAffineTransformMakeScale(1.5, 1.5)
                
                if indexPath.row == (tableView.numberOfRowsInSection(0)-1) && photosSelection.count % 2 != 0 {
                } else {
                    let imageView2: UIImageView = UIImageView(frame:CGRectMake(0, 0, dimension, dimension))
                    imageView2.setImageWithURL(NSURL(string:photosSelection[(index*2)+1])!)
                    cell.imageFrame2.addSubview(imageView2)
                    cell.imageFrame2.clipsToBounds = true
                    imageView2.transform = CGAffineTransformMakeScale(1.5, 1.5)
                    
                }
            }
            return cell
        }
        
    }
    
    
    
    
    //ROW HEIGHTS
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        } else if indexPath.row == 1 {
            return 50
        } else if indexPath.row == 2 {
            return UITableViewAutomaticDimension
        } else {
            return view.frame.width/2
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                
                
                let titleField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleCell
                titleField.titlePlanField.text = self.plan!["title"] as? String
                
                let tagField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TagCell
                let nsArray = self.plan!["tags"]
                let swiftArray = nsArray as AnyObject as! [String]
                let tagsString = swiftArray.joinWithSeparator(", ")
                let tags = tagsString
                tagField.tagsPlanField.text = String(tags)
                
                let bodyField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! BodyCell
                bodyField.bodyPlanField.text = self.plan!["body"] as? String
                
                self.photosSelection = self.plan["imgUrl"] as? Array
                
                var color = self.plan["color"] as? String
                var colorIndex = Int(color!)
                self.view.backgroundColor = colorSet[colorIndex!]
                self.tableView.reloadData()

            }
        }
    }

    
    // SEARCH FOR TAGS
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "searchAgainSegue") {
            
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TagCell
            let svc = segue!.destinationViewController as! SearchViewController;
            svc.searchString = cell.tagsPlanField.text!
            
        }
    }
    
    
    //DEDUPE IMAGES ALREADY SELECTED
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    
    // ADD SELECTED IMAGES
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        
        if segue.sourceViewController.isKindOfClass(SearchViewController) {
            let picker = segue.sourceViewController as! SearchViewController
            if (picker.photosSelected != nil) {
                print(picker.photosSelected)
                let photos = photosSelection + picker.photosSelected
                photosSelection = photos
                let dedupe = removeDuplicates(photosSelection)
                photosSelection = dedupe
                print(photosSelection)
            }
        }
        tableView.reloadData()
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
                
                let titleField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleCell
                let tagField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TagCell
                let bodyField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! BodyCell

                
                if !tagField.tagsPlanField.text!.isEmpty {
                    tags = tagField.tagsPlanField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
                    //print(tags)
                    tags = tags.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
                    //print(tags.count)
                }
                
                object?["title"] = titleField.titlePlanField.text
                object?["tags"] = tags
                object?["body"] = bodyField.bodyPlanField.text
                object?["imgUrl"] = self.photosSelection
                object?.saveInBackground()
            }
        }
    }
    
    // BACK TO HOME
    @IBAction func didPressBack(sender: AnyObject) {
        
        let titleField = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleCell
        if titleField.titlePlanField.text == "" {
            
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