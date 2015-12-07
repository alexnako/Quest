//
//  BodyCell.swift
//  Quest
//
//  Created by Alex Nako on 12/6/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit

class BodyCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var bodyPlanField: UITextView!
    @IBOutlet weak var bodyPlaceholderLabel: UILabel!
    @IBOutlet weak var bodyFieldHeight: NSLayoutConstraint!
    
    var bodyHeight: CGFloat! = 60

    override func awakeFromNib() {
        super.awakeFromNib()
        bodyPlanField.delegate = self
        bodyHeight = 60
        // Initialization code
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        bodyPlanField.sizeToFit()
        bodyPlanField.layoutIfNeeded()
        bodyHeight = bodyPlanField.sizeThatFits(CGSizeMake(bodyPlanField.frame.size.width, CGFloat.max)).height
        if bodyHeight > 60 {
            bodyFieldHeight.constant = bodyHeight
        }
        
        if !bodyPlanField.text.isEmpty {
            bodyPlaceholderLabel.hidden = true
        } else {
            bodyPlaceholderLabel.hidden = false
        }
        
        tableView?.beginUpdates()
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
