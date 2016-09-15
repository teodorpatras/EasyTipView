//
//  UIKitExtensions.swift
//  EasyTipView
//
//  Created by Teodor Patras on 29/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

import Foundation

// MARK: - UIBarItem extension -

extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.valueForKey("view") as? UIView
    }
}

// MARK:- UIView extension -

extension UIView {
    
    func originWithinDistantSuperView(superview: UIView?) -> CGPoint
    {
        if self.superview != nil {
            return viewOriginInSuperview(self.superview!, subviewOrigin: self.frame.origin, refSuperview : superview)
        }else{
            return self.frame.origin
        }
    }
    
    func hasSuperview (superview: UIView) -> Bool{
        return viewHasSuperview(self, superview: superview)
    }
    
    private func viewHasSuperview (view: UIView, superview: UIView) -> Bool {
        if let sview = view.superview {
            if sview === superview {
                return true
            }else{
                return viewHasSuperview(sview, superview: superview)
            }
        }else{
            return false
        }
    }
    
    private func viewOriginInSuperview(sview: UIView, subviewOrigin sorigin: CGPoint, refSuperview: UIView?) -> CGPoint {
        
        if let superview = sview.superview {
            if let ref = refSuperview {
                if sview === ref {
                    return sorigin
                }else{
                    return viewOriginInSuperview(superview, subviewOrigin: CGPointMake(sview.frame.origin.x + sorigin.x, sview.frame.origin.y + sorigin.y), refSuperview: ref)
                }
            }else{
                return viewOriginInSuperview(superview, subviewOrigin: CGPointMake(sview.frame.origin.x + sorigin.x, sview.frame.origin.y + sorigin.y), refSuperview: nil)
            }
        }else{
            return CGPointMake(sview.frame.origin.x + sorigin.x, sview.frame.origin.y + sorigin.y)
        }
    }
}

// MARK:- CGRect extension -

extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.origin.y
        }
        
        set {
            self.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
         return self.size.width
        }
        
        set {
            self.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.size.height
        }
        
        set{
            self.size.height = newValue
        }
    }
    
    var maxX: CGFloat {
        return CGRectGetMaxX(self)
    }
    
    var maxY: CGFloat {
        return CGRectGetMaxY(self)
    }
    
    var center: CGPoint {
        return CGPointMake(self.x + self.width / 2, self.y + self.height / 2)
    }
}
