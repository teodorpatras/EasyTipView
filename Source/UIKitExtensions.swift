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

}

// MARK:- CGRect extension -

extension CGRect {
    var x: CGFloat {
        return self.origin.x
    }
    
    var y: CGFloat {
        return self.origin.y
    }
    
    var width: CGFloat {
        return self.size.width
    }
    
    var height: CGFloat {
        return self.size.height
    }
}
