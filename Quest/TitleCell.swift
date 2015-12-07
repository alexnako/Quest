//
//  TitleCell.swift
//  Quest
//
//  Created by Alex Nako on 12/6/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var titlePlanField: UITextView!
    @IBOutlet weak var titlePlaceholder: UILabel!
    @IBOutlet weak var titleFieldHeight: NSLayoutConstraint!
    
    
    var titleHeight: CGFloat! = 88
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titlePlanField.delegate = self
        titleHeight = 88
        titleFieldHeight.constant = 88
    }

    
    func textViewDidChangeSelection(textView: UITextView) {
        
        titlePlanField.sizeToFit()
        titlePlanField.layoutIfNeeded()
        titleHeight = titlePlanField.sizeThatFits(CGSizeMake(titlePlanField.frame.size.width, CGFloat.max)).height
        if titleHeight > 60 {
            titleFieldHeight.constant = titleHeight
        }
        tableView?.beginUpdates()
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
            
        
        if !titlePlanField.text.isEmpty {
            titlePlaceholder.hidden = true
        } else {
            titlePlaceholder.hidden = false
        }
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
