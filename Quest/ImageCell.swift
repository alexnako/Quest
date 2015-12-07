//
//  ImageCell.swift
//  Quest
//
//  Created by Alex Nako on 12/6/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var imageFrame1: UIView!
    @IBOutlet weak var imageFrame2: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
