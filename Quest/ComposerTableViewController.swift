//
//  ComposerTableViewController.swift
//  Quest
//
//  Created by Alex Nako on 12/6/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse
import AFNetworking


var blueCard:UIColor! = UIColor(red: 100/255, green: 140/255, blue: 190/255, alpha: 1)
var greenCard: UIColor! = UIColor(red: 100/255, green: 195/255, blue: 175/255, alpha: 1)

var planColor:[UIColor]! = [blueCard,greenCard]



class ComposerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!

    var photosSelection: [String]!
    var photosSelected: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cardColor = planColor.randomItem()
        photosSelected = []
        photosSelection = []
        
        
        view.backgroundColor = cardColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        closeButton.tintColor = UIColor.whiteColor()
        createButton.layer.borderWidth = 1;
        createButton.layer.borderColor = UIColor.whiteColor().CGColor
        createButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        createButton.layer.cornerRadius = 4;
        createButton.enabled = false

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
    
    
    // SEARCH FOR TAGS
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "searchSegue") {
            
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

    
    // CREATING PLAN
    @IBAction func didPressCreate(sender: AnyObject) {
        let plan = PFObject(className: "Plan")
        
        
        //CONVERTING TAG STRING INTO ARRAY
        var tags = []
        
        let titleField = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleCell
        let tagField = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TagCell
        let bodyField = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! BodyCell

        
        if !tagField.tagsPlanField.text!.isEmpty {
            tags = tagField.tagsPlanField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
            //print(tags)
            tags = tags.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
            //print(tags.count)
        }
        
        plan["title"] = titleField.titlePlanField.text!
        plan["user"] = PFUser.currentUser()?.username
        plan["tags"] = tags
        plan["body"] = bodyField.bodyPlanField.text!
        plan["imgUrl"] = photosSelection
        
        // SAVING PLAN
        plan.saveInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            if error == nil {
                // print("create success")
                titleField.titlePlanField.text = ""
                tagField.tagsPlanField.text = ""
                bodyField.bodyPlanField.text = ""
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                
            } else {
                print("error\(error)")
            }
        }

    }
    
    
    // CANCELLING PLAN
    @IBAction func didPressCancel(sender: AnyObject) {
        
        
        let titleField = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleCell
        let tagField = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! TagCell
        let bodyField = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! BodyCell
        
        if titleField.titlePlanField.text != "" || bodyField.bodyPlanField.text != "" || tagField.tagsPlanField.text != "" {
            
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

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}