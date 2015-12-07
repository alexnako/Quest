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

    var searchString:String!
    var objectId: String!
    
    var photos: [NSDictionary]!
    var photosSelected: [String]!


    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.text = searchString
        photos = []
        photosSelected = []
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        
        // COLLECTION VIEW LAYOUT
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
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
            if searchField.text != nil {
            
            //INSTAGRAM
            let url = NSURL(string: "https://api.instagram.com/v1/tags/\(searchField.text!)/media/recent?access_token=3044669.1677ed0.c6d74cb75c3b444fadfd4ca68a6e8975")!
                
            // FLICKR
            //let url = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=\(searchField.text!)&tagmode=any&format=json&nojsoncallback=1")!
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                
                //CREATING DICTIONARY FROM JASON
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

                //INSTAGRAM
                self.photos = dictionary["data"] as! [NSDictionary]

                //FLICKR
                //self.photos = dictionary["items"] as! [NSDictionary]
                self.collectionView.reloadData()
            }
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
        
        // INSTAGRAM
        let urlString = photo.valueForKeyPath("images.low_resolution.url") as! String
        cell.imgCell.setImageWithURL(NSURL(string: urlString)!)
        cell.imgCell.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        return cell

        
        //FLICKR
        //let urlString = photo.valueForKeyPath("media.m") as! String
    }

    //IDENTIFY CELL CLICKED
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollViewCell
        
        
        // STORING URL
        let photo = self.photos[indexPath.row]
        let urlString = photo.valueForKeyPath("images.low_resolution.url") as! String
        
        if cell.checkButton.selected == true {
            cell.checkButton.selected = false
            photosSelected = photosSelected.filter() { $0 != urlString }
        } else {
            cell.checkButton.selected = true
            photosSelected.append(urlString)
        }
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // SEARCH FOR TAGS
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if parentViewController is ComposerTableViewController {
            let initialSearch = segue.destinationViewController as! ComposerTableViewController;
            initialSearch.photosSelected = photosSelected
        } else if parentViewController is ReaderTableViewController {
            let editSearch = segue.destinationViewController as! ReaderTableViewController;
            editSearch.photosSelected = photosSelected
        
        }
    }

    
}
