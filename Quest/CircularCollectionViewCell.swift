//
//  CircularCollectionViewCell.swift
//  Quest
//
//  Created by Haihong Wang on 11/27/15.
//  Adopted from http://www.raywenderlich.com/107687/uicollectionview-custom-layout-tutorial-spinning-wheel
//  Copyright © 2015 Haihong Wang. All rights reserved.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var planTitle: UILabel!
    
    var title: String = "" {
        didSet {
            // Change the plan title in label
            planTitle!.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = UIColor.clearColor()
        contentView.layer.cornerRadius = 2
        //contentView.layer.borderColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0).CGColor
        //contentView.layer.borderWidth = 1
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.mainScreen().scale
        contentView.clipsToBounds = true
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
    }

}
