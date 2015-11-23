//
//  SearchViewController.swift
//  Quest
//
//  Created by Alex Nako on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    var toPass:String!
    var photos: [NSDictionary]!


    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.text = toPass
        photos = []
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        
        // COLLECTION VIEW LAYOUT
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.greenColor()
        
        searchImages()
        
    }
    
    func searchImages () {
        
        // REQUESTING INSTAGRAM
        let url = NSURL(string: "https://api.instagram.com/v1/tags/\(searchField.text!)/media/recent?access_token=3044669.1677ed0.c6d74cb75c3b444fadfd4ca68a6e8975")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            //CREATING DICTIONARY FROM JASON
            let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            self.photos = dictionary["data"] as! [NSDictionary]
            print(self.photos)
            self.collectionView.reloadData()
        }
        
    }
    
    @IBAction func didPressSearch(sender: AnyObject) {
        searchImages()
    }
    
    //SET NUMBER OF CELLS IN COLLECTIONVIEW
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    //LOAD IMAGES IN COLLECTION VIEW
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CollViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollViewCell
        
        let photo = self.photos[indexPath.row]
        let urlString = photo.valueForKeyPath("images.low_resolution.url") as! String
        cell.imgCell.setImageWithURL(NSURL(string: urlString)!)
        
        return cell
    }

    //IDENTIFY CELL CLICKED
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



    @IBAction func didPressBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
