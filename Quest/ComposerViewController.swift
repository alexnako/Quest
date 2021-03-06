//
//  ComposerViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class ComposerViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleField: UITextView!
    @IBOutlet weak var titlePlaceholder: UILabel!
    @IBOutlet weak var tagsPlanField: UITextField!
    @IBOutlet weak var freetextPlanField: UITextView!
    @IBOutlet weak var bodyPlanField: UITextView!
    @IBOutlet weak var bodyPlaceholderLabel: UILabel!
    @IBOutlet weak var photoDrawer: UIView!
    
    @IBOutlet weak var titleFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var bodyPlanHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchTagsButton: UIButton!
    
    var photosSelection: [String]!
    var photosSelected: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        
        photosSelected = []
        photosSelection = []
        
        createButton.layer.cornerRadius = 4;
        createButton.layer.borderWidth = 1;
        createButton.layer.borderColor = UIColor.blackColor().CGColor        
        
        bodyPlanField.delegate = self
        titleField.delegate = self
        tagsPlanField.delegate = self
        tagsPlanField.addTarget(self, action: "tagsAdded:", forControlEvents: UIControlEvents.EditingChanged)

        
        createButton.enabled = false
        createButton.alpha = 0.1
        
        searchTagsButton.enabled = false
        searchTagsButton.alpha = 0

    }
    
    @IBAction func didPressSelected(sender: AnyObject) {
        print(photosSelected)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
                
                // ENABLING CREATE IF THERE IS A TITLE
                createButton.enabled = true
                createButton.alpha = 1
            } else {
                titlePlaceholder.hidden = false
                
                // DISABLING CREATE IF NO TITLE
                createButton.enabled = false
                createButton.alpha = 0.1
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

    // ENABLING TAG SEARCH
    func tagsAdded(textField: UITextField) {
        if !tagsPlanField.text!.isEmpty {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.searchTagsButton.alpha = 1
                }, completion: { (Bool) -> Void in
                    self.searchTagsButton.enabled = true
            })
        } else {
            searchTagsButton.enabled = false
            searchTagsButton.alpha = 0
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if tagsPlanField.text == "" {
            searchTagsButton.enabled = false
            searchTagsButton.alpha = 0
        }
    }
    
    
    // SEARCH FOR TAGS
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "segueSearch") {
            var svc = segue!.destinationViewController as! SearchViewController;
            svc.searchString = tagsPlanField.text
            
        }
    }
    
    // ADD SELECTED IMAGES
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        
        if segue.sourceViewController.isKindOfClass(SearchViewController) {
            let picker = segue.sourceViewController as! SearchViewController
            if (picker.photosSelected != nil) {
                //print(picker.photosSelected)
                let photos = photosSelection + picker.photosSelected
                photosSelection = photos
                let dedupe = removeDuplicates(photosSelection)
                photosSelection = dedupe
                //print(photosSelection)
            }
        }
        refreshPhotoDrawer ()
    }
    
    // VISUALIZING SELECTED IMAGES
    func refreshPhotoDrawer () {
        //print(photosSelection.count)
        for var i = 0; i <= (photosSelection.count-1); i++ {
            let dimension = self.view.frame.width/2
            let idivider = CGFloat(i)/2
            let positioner = floor(idivider) * dimension
            var imageFrame: UIView
            if i % 2 == 0 {
                imageFrame  = UIView(frame:CGRectMake(0, positioner, dimension, dimension));
            } else {
                imageFrame  = UIView(frame:CGRectMake(dimension, positioner, dimension, dimension));
            }
            imageFrame.clipsToBounds = true
            photoDrawer.addSubview(imageFrame)
            var imageView: UIImageView = UIImageView(frame:CGRectMake(0, 0, dimension, dimension))
            imageFrame.addSubview(imageView)
            imageView.setImageWithURL(NSURL(string: photosSelection[i])!)
            imageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
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
    
    
    // CREATING PLAN
    @IBAction func didPressCreate(sender: AnyObject) {
        
        let plan = PFObject(className: "Plan")

        
        //CONVERTING TAG STRING INTO ARRAY
        var tags = []
            if !tagsPlanField.text!.isEmpty {
                tags = tagsPlanField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ","))
                //print(tags)
                tags = tags.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) }
                //print(tags.count)
            }
    
        plan["title"] = titleField.text
        plan["user"] = PFUser.currentUser()?.username
        plan["tags"] = tags
        plan["body"] = bodyPlanField.text
        plan["imgUrl"] = photosSelection
    
        // SAVING PLAN
        plan.saveInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            if error == nil {
                // print("create success")
                self.titleField.text = ""
                self.tagsPlanField.text = ""
                self.bodyPlanField.text = ""
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
                
            } else {
                print("error\(error)")
            }
        }
    
        
    }
    
    // CANCELLING PLAN CREATION
    @IBAction func didPressCancel(sender: AnyObject) {
        
        if titleField.text != "" || bodyPlanField.text != "" || tagsPlanField.text != "" {
        
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



