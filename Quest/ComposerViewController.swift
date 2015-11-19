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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressCreate(sender: AnyObject) {
        let plan = PFObject(className: "Plan")
        
        plan["title"] = titlePlanField.text
        plan["tags"] = tagsPlanField.text
        plan["body"] = bodyPlanField.text
        
        plan.saveInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            print("create success")
        }

    }

    
}
