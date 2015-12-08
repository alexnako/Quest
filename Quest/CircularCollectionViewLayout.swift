//
//  CircularCollectionViewLayout.swift
//  Quest
//
//  Created by Haihong Wang on 11/27/15.
//  Adopted from http://www.raywenderlich.com/107687/uicollectionview-custom-layout-tutorial-spinning-wheel
//  Copyright © 2015 Haihong Wang. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    // 1 You need anchorPoint because the rotation happens around a point that isn’t the center
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        // 2 While setting angle, you internally set transform to be equal to a rotation of angle radians. You also want cells on the right to overlap the ones to their left, so you set zIndex to a function that increases in angle. Since angle is expressed in radians, you amplify its value by 1,000,000 to ensure that adjacent values don’t get rounded up to the same value of zIndex, which is an Int.
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransformMakeRotation(angle)
        }
    }
    // This overrides copyWithZone(). Subclasses of UICollectionViewLayoutAttributes need to conform to the NSCopying protocol because the attribute’s objects can be copied internally when the collection view is performing a layout. You override this method to guarantee that both the anchorPoint and angle properties are set when the object is copied.
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copiedAttributes: CircularCollectionViewLayoutAttributes =
        super.copyWithZone(zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    // Default size
    var itemSize = CGSize(width: 240, height: 320)
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItemsInSection(0) > 0 ?
            -CGFloat(collectionView!.numberOfItemsInSection(0) - 1) * anglePerItem : 0
    }
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize().width -
            CGRectGetWidth(collectionView!.bounds))
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItemsInSection(0)) * itemSize.width,
            height: CGRectGetHeight(collectionView!.bounds))
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let centerX = collectionView!.contentOffset.x + (CGRectGetWidth(collectionView!.bounds) / 2.0)
        itemSize.width = CGRectGetWidth(collectionView!.bounds) * 0.7
        itemSize.height = CGRectGetHeight(collectionView!.bounds) * 0.66
        radius = itemSize.height * 2
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        attributesList = (0..<collectionView!.numberOfItemsInSection(0)).map { (i)
            -> CircularCollectionViewLayoutAttributes in
            // 1 Create an instance of CircularCollectionViewLayoutAttributes for each index path, and then set its size.
            let attributes = CircularCollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i,
                inSection: 0))
            attributes.size = self.itemSize
            // 2 Position each item at the center of the screen
            attributes.center = CGPoint(x: centerX, y: CGRectGetMidY(self.collectionView!.bounds))
            // 3 Rotate each item by the amount anglePerItem * i, in radians.
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> (UICollectionViewLayoutAttributes!) {
            return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // "Snapping" on the edge of cards
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExtreme/(collectionViewContentSize().width -
            CGRectGetWidth(collectionView!.bounds))
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
}

