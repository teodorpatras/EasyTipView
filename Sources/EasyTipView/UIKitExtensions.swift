//
//  UIKitExtensions.swift
//  EasyTipView
//
//  Created by Teodor Patras on 29/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.
//

#if canImport(UIKit)
import UIKit

// MARK: - UIBarItem extension -

extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.value(forKey: "view") as? UIView
    }
}

// MARK:- UIView extension -

extension UIView {
    
    func hasSuperview(_ superview: UIView) -> Bool{
        return viewHasSuperview(self, superview: superview)
    }
    
    fileprivate func viewHasSuperview(_ view: UIView, superview: UIView) -> Bool {
        if let sview = view.superview {
            if sview === superview {
                return true
            } else{
                return viewHasSuperview(sview, superview: superview)
            }
        } else{
            return false
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
    
    var center: CGPoint {
        return CGPoint(x: self.x + self.width / 2, y: self.y + self.height / 2)
    }
}
#endif
