//
//  ReaderViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/24/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {

    var passedValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedValue)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
