//
//  HomeViewCell.swift
//  Quest
//
//  Created by Benji Renzo Kuroda on 11/19/15.
//  Copyright © 2015 Alex Nako. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {
    
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
