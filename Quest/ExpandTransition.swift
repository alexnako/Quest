//
//  FadeTransition.swift
//  transitionDemo
//
//  Created by Timothy Lee on 11/4/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ExpandTransition: BaseTransition {
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        let cardHome = fromViewController as! HomeViewController
        cardHome.selectedCard.frame.origin.y = 150
        cardHome.selectedCard.transform = CGAffineTransformMakeScale(0.8, 0.8)
        cardHome.selectedCard.backgroundColor = cardHome.planToEditColor
        cardHome.selectedCardTitle.text = cardHome.planToEditTitle
        cardHome.selectedCard.alpha = 1
        cardHome.selectedCard.hidden = false
        toViewController.view.alpha = 0
        
        UIView.animateWithDuration(0.9, delay: 0.1, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            cardHome.selectedCard.transform = CGAffineTransformMakeScale(1, 1)
            cardHome.selectedCard.frame.origin.y = 0
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    toViewController.view.alpha = 1
                    }, completion: { (Bool) -> Void in
                        self.finish()
                })
        }
        
        
        
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        let cardHome = toViewController as! HomeViewController
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            fromViewController.view.alpha = 0
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(1.6, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    cardHome.selectedCard.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    cardHome.selectedCard.frame.origin.y = 150
                    cardHome.selectedCard.alpha = 0
                    }) { (Bool) -> Void in
                        cardHome.selectedCard.hidden = true
                        self.finish()
                        
                }
        }
        
        
        
    }
}