//
// EasyTipView.swift
//
// Copyright (c) 2015 Teodor Patraş
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

@objc public protocol EasyTipViewDelegate {
    func easyTipViewDidDismiss(tipView : EasyTipView)
}

public class EasyTipView: UIView {
    
    
    // MARK:- Nested types -
    
    public enum ArrowPosition {
        case Top
        case Bottom
    }
    
    public struct Preferences {
        
        public var systemFontSize          :   CGFloat
        public var textColor               :   UIColor
        public var bubbleColor             :   UIColor
        public var arrowPosition           :   ArrowPosition
        public var font                    :   UIFont?
        public var textAlignment           :   NSTextAlignment
        
        public init() {
            systemFontSize = 15
            textColor = UIColor.whiteColor()
            bubbleColor = UIColor.redColor()
            arrowPosition = .Bottom
            textAlignment = .Center
        }
    }
    
    
    // MARK:- Constants -
    
    private struct Constants {
        static let arrowHeight          :   CGFloat =   5
        static let arrowWidth           :   CGFloat =   10
        static let bubbleHInset         :   CGFloat =   10
        static let bubbleVInset         :   CGFloat =   1
        static let textHInset           :   CGFloat =   10
        static let textVInset           :   CGFloat =   5
        static let bubbleCornerRadius   :   CGFloat =   5
        static let maxWidth             :   CGFloat =   200
    }
    
    // MARK:- Variables -
    
    override public var backgroundColor : UIColor? {
        didSet {
            guard let color = backgroundColor
                where color != UIColor.clearColor() else {return}
            
            self.preferences.bubbleColor = color
            backgroundColor = UIColor.clearColor()
        }
    }
    
    override public var description : String {
        
        let type = _stdlib_getDemangledTypeName(self).componentsSeparatedByString(".").last!
        
        return "<< \(type) with text : '\(self.text)' >>"
    }
    
    private weak var presentingView :   UIView?
    private var arrowTip            =   CGPointZero
    private var preferences         :   Preferences
    weak var delegate               :   EasyTipViewDelegate?
    
    private let font                :   UIFont
    private let text                :   NSString
    
    private lazy var textSize : CGSize = {
        
        [unowned self] in
        
        var attributes : [String : AnyObject] = [NSFontAttributeName : self.font]
        
        var textSize = self.text.boundingRectWithSize(CGSizeMake(EasyTipView.Constants.maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        textSize.width = ceil(textSize.width)
        textSize.height = ceil(textSize.height)
        
        if textSize.width < EasyTipView.Constants.arrowWidth {
            textSize.width = EasyTipView.Constants.arrowWidth
        }
        
        return textSize
        }()
    
    private lazy var contentSize : CGSize = {
        
        [unowned self] in
        
        var contentSize = CGSizeMake(self.textSize.width + Constants.textHInset * 2 + Constants.bubbleHInset * 2, self.textSize.height + Constants.textVInset * 2 + Constants.bubbleVInset * 2 + Constants.arrowHeight)
        
        return contentSize
        }()
    
    // MARK:- Static preferences -
    
    private struct GlobalPreferences {
        private static var preferences : Preferences = Preferences()
    }
    
    public class func setGlobalPreferences (preferences : Preferences) {
        GlobalPreferences.preferences = preferences
    }
    
    public class func globalPreferences() -> Preferences {
        return GlobalPreferences.preferences
    }
    
    // MARK:- Initializer -
    
    public init (text : NSString, preferences: Preferences?, delegate : EasyTipViewDelegate?){
        
        self.text = text
        
        if let p = preferences {
            self.preferences = p
        } else {
            self.preferences = EasyTipView.GlobalPreferences.preferences
        }
        
        if let font = self.preferences.font {
            self.font = font
        }else{
            self.font = UIFont.systemFontOfSize(self.preferences.systemFontSize)
        }
        
        self.delegate = delegate
        
        super.init(frame : CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleRotation", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleRotation () {
        guard let sview = self.superview
            where self.presentingView != nil else { return }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.arrangeInSuperview(sview)
            self.setNeedsDisplay()
        })
    }
    
    /**
    NSCoding not supported. Use init(text, preferences, delegate) instead!
    */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported. Use init(text, preferences, delegate) instead!")
    }
    
    // MARK:- Class functions -
    
    public class func showAnimated(animated : Bool, forView view : UIView, withinSuperview superview : UIView?, text :  NSString, preferences: Preferences?, delegate : EasyTipViewDelegate?){
        
        let ev = EasyTipView(text: text, preferences : preferences, delegate : delegate)
        
        ev.showForView(view, withinSuperview: superview, animated: animated)
    }
    
    public class func showAnimated(animated : Bool, forItem item : UIBarButtonItem, withinSuperview superview : UIView?, text : NSString, preferences: Preferences?, delegate : EasyTipViewDelegate?){
        
        if let view = item.customView {
            self.showAnimated(animated, forView: view, withinSuperview: superview, text: text, preferences: preferences, delegate: delegate)
        }else{
            if let view = item.valueForKey("view") as? UIView {
                self.showAnimated(animated, forView: view, withinSuperview: superview, text: text, preferences: preferences, delegate: delegate)
            }
        }
    }
    
    // MARK:- Instance methods -
    
    public func showForItem(item : UIBarButtonItem, withinSuperView sview : UIView?, animated : Bool) {
        if let view = item.customView {
            self.showForView(view, withinSuperview: sview, animated : animated)
        }else{
            if let view = item.valueForKey("view") as? UIView {
                self.showForView(view, withinSuperview: sview, animated: animated)
            }
        }
    }
    
    public func showForView(view : UIView, withinSuperview sview : UIView?, animated : Bool) {
        
        if let v = sview {
            assert(view.hasSuperview(v), "The supplied superview <\(v)> is not a direct nor an indirect superview of the supplied reference view <\(view)>. The superview passed to this method should be a direct or an indirect superview of the reference view. To display the tooltip on the window, pass nil as the superview parameter.")
        }
        
        let superview = sview ?? UIApplication.sharedApplication().windows.last!
        
        self.presentingView = view
        
        self.arrangeInSuperview(superview)
        
        self.transform = CGAffineTransformMakeScale(0, 0)
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap")
        self.addGestureRecognizer(tap)
        
        superview.addSubview(self)
        
        if animated {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }else{
            self.transform = CGAffineTransformIdentity
        }
    }
    
    private func arrangeInSuperview(superview : UIView) {
        
        let position = self.preferences.arrowPosition
        
        let refViewOrigin = self.presentingView!.originWithinDistantSuperView(superview)
        let refViewSize = self.presentingView!.frame.size
        let refViewCenter = CGPointMake(refViewOrigin.x + refViewSize.width / 2, refViewOrigin.y + refViewSize.height / 2)
        
        let xOrigin = refViewCenter.x - self.contentSize.width / 2
        let yOrigin = position == .Bottom ? refViewOrigin.y - self.contentSize.height : refViewOrigin.y + refViewSize.height
        
        var frame = CGRectMake(xOrigin, yOrigin, self.contentSize.width, self.contentSize.height)
        
        if frame.origin.x < 0 {
            frame.origin.x =  0
        } else if CGRectGetMaxX(frame) > CGRectGetWidth(superview.frame){
            frame.origin.x = superview.frame.width - CGRectGetWidth(frame)
        }
        
        if position == .Top {
            if CGRectGetMaxY(frame) > CGRectGetHeight(superview.frame){
                self.preferences.arrowPosition = .Bottom
                frame.origin.y = refViewOrigin.y - self.contentSize.height
            }
        }else{
            if CGRectGetMinY(frame) < 0 {
                self.preferences.arrowPosition = .Top
                frame.origin.y = refViewOrigin.y + refViewSize.height
            }
        }
        
        var arrowTipXOrigin : CGFloat
        
        if CGRectGetWidth(frame) < refViewSize.width {
            arrowTipXOrigin = self.contentSize.width / 2
        } else {
            arrowTipXOrigin = abs(frame.origin.x - refViewOrigin.x) + refViewSize.width / 2
        }
        
        self.arrowTip = CGPointMake(arrowTipXOrigin, self.preferences.arrowPosition == .Top ? Constants.bubbleVInset : self.contentSize.height - Constants.bubbleVInset)
        self.frame = frame
    }
    
    
    public func dismissWithCompletion(completion : ((finished : Bool) -> Void)?){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.3, 0.3)
            self.alpha = 0
            }) { (finished) -> Void in
                completion?(finished: finished)
                self.removeFromSuperview()
        }
    }
    
    // MARK:- Callbacks -
    
    public func handleTap () {
        self.dismissWithCompletion { (finished) -> Void in
            self.delegate?.easyTipViewDidDismiss(self)
        }
    }
    
    // MARK:- Drawing -
    
    override public func drawRect(rect: CGRect) {
        
        let bubbleWidth = self.contentSize.width - 2 * Constants.bubbleHInset
        let bubbleHeight = self.contentSize.height - 2 * Constants.bubbleVInset - Constants.arrowHeight
        
        let arrowPosition = self.preferences.arrowPosition
        
        let bubbleXOrigin = Constants.bubbleHInset
        let bubbleYOrigin = arrowPosition == .Bottom ? Constants.bubbleVInset : Constants.bubbleVInset + Constants.arrowHeight
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState (context)
        
        let contourPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(contourPath, nil, self.arrowTip.x, self.arrowTip.y)
        CGPathAddLineToPoint(contourPath, nil, self.arrowTip.x - Constants.arrowWidth / 2, self.arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * Constants.arrowHeight)
        
        if arrowPosition == .Top {
            
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin, bubbleXOrigin, bubbleYOrigin + bubbleHeight, Constants.bubbleCornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin + bubbleHeight, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, Constants.bubbleCornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, bubbleXOrigin + bubbleWidth, bubbleYOrigin, Constants.bubbleCornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin, bubbleXOrigin, bubbleYOrigin, Constants.bubbleCornerRadius)
            
        } else {
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin + bubbleHeight, bubbleXOrigin, bubbleYOrigin, Constants.bubbleCornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin, bubbleXOrigin + bubbleWidth, bubbleYOrigin, Constants.bubbleCornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, Constants.bubbleCornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, bubbleXOrigin, bubbleYOrigin + bubbleHeight, Constants.bubbleCornerRadius)
        }
        
        CGPathAddLineToPoint(contourPath, nil, self.arrowTip.x + Constants.arrowWidth / 2, self.arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * Constants.arrowHeight)
        
        CGPathCloseSubpath(contourPath)
        CGContextAddPath(context, contourPath)
        CGContextClip(context)
        
        CGContextSetFillColorWithColor(context, self.preferences.bubbleColor.CGColor)
        CGContextFillRect(context, self.bounds)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.preferences.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        let textRect = CGRectMake(bubbleXOrigin + (bubbleWidth - self.textSize.width) / 2, bubbleYOrigin + (bubbleHeight - self.textSize.height) / 2, textSize.width, textSize.height)
        
        
        self.text.drawInRect(textRect, withAttributes: [NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.preferences.textColor, NSParagraphStyleAttributeName : paragraphStyle])
        
        CGContextRestoreGState(context)
    }
}

// MARK:- UIView extension -

private extension UIView {
    
    func originWithinDistantSuperView (superview : UIView?) -> CGPoint
    {
        if self.superview != nil {
            return viewOriginInSuperview(self.superview!, subviewOrigin: self.frame.origin, refSuperview : superview)
        }else{
            return self.frame.origin
        }
    }
    
    func hasSuperview (superview : UIView) -> Bool{
        return viewHasSuperview(self, superview: superview)
    }
    
    func viewHasSuperview (view : UIView, superview : UIView) -> Bool {
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
    
    func viewOriginInSuperview(sview : UIView, subviewOrigin sorigin: CGPoint, refSuperview : UIView?) -> CGPoint {
        
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