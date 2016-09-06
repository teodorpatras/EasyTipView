////
////  UIKitExtensions.swift
////  EasyTipView
////
////  Created by Teodor Patras on 29/06/16.
////  Copyright © 2016 teodorpatras. All rights reserved.
////
//
//import Foundation
//
//// MARK: - UIBarItem extension -
//
//extension UIBarItem {
//    var view: UIView? {
//        if let item = self as? UIBarButtonItem, let customView = item.customView {
//            return customView
//        }
//        return self.value(forKey: "view") as? UIView
//    }
//}
//
//// MARK:- UIView extension -
//
//extension UIView {
//    
//    func originWithinDistantSuperView(_ superview: UIView?) -> CGPoint
//    {
//        if self.superview != nil {
//            return viewOriginInSuperview(self.superview!, subviewOrigin: self.frame.origin, refSuperview : superview)
//        }else{
//            return self.frame.origin
//        }
//    }
//    
//    func hasSuperview (_ superview: UIView) -> Bool{
//        return viewHasSuperview(self, superview: superview)
//    }
//    
//    fileprivate func viewHasSuperview (_ view: UIView, superview: UIView) -> Bool {
//        if let sview = view.superview {
//            if sview === superview {
//                return true
//            }else{
//                return viewHasSuperview(sview, superview: superview)
//            }
//        }else{
//            return false
//        }
//    }
//    
//    fileprivate func viewOriginInSuperview(_ sview: UIView, subviewOrigin sorigin: CGPoint, refSuperview: UIView?) -> CGPoint {
//        
//        if let superview = sview.superview {
//            if let ref = refSuperview {
//                if sview === ref {
//                    return sorigin
//                }else{
//                    return viewOriginInSuperview(superview, subviewOrigin: CGPoint(x: sview.frame.origin.x + sorigin.x, y: sview.frame.origin.y + sorigin.y), refSuperview: ref)
//                }
//            }else{
//                return viewOriginInSuperview(superview, subviewOrigin: CGPoint(x: sview.frame.origin.x + sorigin.x, y: sview.frame.origin.y + sorigin.y), refSuperview: nil)
//            }
//        }else{
//            return CGPoint(x: sview.frame.origin.x + sorigin.x, y: sview.frame.origin.y + sorigin.y)
//        }
//    }
//}
//
//// MARK:- CGRect extension -
//
//extension CGRect {
//    var x: CGFloat {
//        get {
//            return self.origin.x
//        }
//        set {
//            self.origin.x = newValue
//        }
//    }
//    
//    var y: CGFloat {
//        get {
//            return self.origin.y
//        }
//        
//        set {
//            self.origin.y = newValue
//        }
//    }
//    
//    var width: CGFloat {
//        get {
//         return self.size.width
//        }
//        
//        set {
//            self.size.width = newValue
//        }
//    }
//    
//    var height: CGFloat {
//        get {
//            return self.size.height
//        }
//        
//        set{
//            self.size.height = newValue
//        }
//    }
//    
//    var center: CGPoint {
//        return CGPoint(x: self.x + self.width / 2, y: self.y + self.height / 2)
//    }
//}
