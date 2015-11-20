//
//  HomeViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import AFNetworking

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var homeTableView: UITableView!
    
    var eventTitles: [String]!
    var eventDates: [String]!
    var eventLocation: [String]!
    var eventPhoto: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        
        eventTitles = ["Surfing", "Hiking", "Dinner"]
        
        eventDates = ["November 14, 2015", "November 15, 2015", "November 15, 2015"]
        
        eventLocation = ["Los Angeles, CA", "Los Angeles, CA", "Los Angeles, CA"]
        
        eventPhoto = []
        
        let url = NSURL(string: "https://api.instagram.com/v1/media/search?lat=48.858844&lng=2.294351&client_id=14160aae910f460d8e196cde8a30461c")!
        
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
                as! NSDictionary
            
            self.eventPhoto = dictionary["data"] as! [NSDictionary]
            
            self.homeTableView.reloadData()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("HomeViewCell") as! HomeViewCell
        
        var eventPhotos = eventPhoto[indexPath.row]
        
        let URLString = eventPhoto.valueForKeyPath("images.low_resolution.url") as! String
        
        cell.eventImageView.setImageWithURL(NSURL(string: URLString)!)
        
        
        print(URLString)
        
        
        
        return cell
        
    }


}
