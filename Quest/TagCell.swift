//
//  TagCell.swift
//  Quest
//
//  Created by Alex Nako on 12/6/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell, UITextFieldDelegate {

    
    
    @IBOutlet weak var tagsPlanField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchButton.tintColor = UIColor.whiteColor()
        searchButton.enabled = false
        searchButton.alpha = 0
        tagsPlanField.delegate = self
        tagsPlanField.addTarget(self, action: "tagsAdded:", forControlEvents: UIControlEvents.EditingChanged)

        
        
        tagsPlanField.attributedPlaceholder = NSAttributedString(string:"Tags",
            attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)])

        // Initialization code
    }
    
    
    // ENABLING TAG SEARCH
    func tagsAdded(textField: UITextField) {
        if !tagsPlanField.text!.isEmpty {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.searchButton.alpha = 1
                }, completion: { (Bool) -> Void in
                    self.searchButton.enabled = true
            })
        } else {
            searchButton.enabled = false
            searchButton.alpha = 0
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if tagsPlanField.text == "" {
            searchButton.enabled = false
            searchButton.alpha = 0
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
