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

public protocol EasyTipViewDelegate : class {
    func easyTipViewDidDismiss(tipView : EasyTipView)
}

public class EasyTipView: UIView {
    
    
    // MARK:- Nested types -
    
    public enum ArrowPosition {
        case Top
        case Bottom
    }
    
    public struct Preferences {
        
        public struct Drawing {
            public var bubbleCornerRadius  = CGFloat(5)
            public var arrowHeight         = CGFloat(5)
            public var arrowWidth          = CGFloat(10)
            public var systemFontSize      = CGFloat(15)
            public var textColor           = UIColor.whiteColor()
            public var bubbleColor         = UIColor.redColor()
            public var arrowPosition       = ArrowPosition.Bottom
            public var textAlignment       = NSTextAlignment.Center
            public var font                : UIFont?
        }
        
        public struct Positioning {
            public var bubbleHInset         = CGFloat(10)
            public var bubbleVInset         = CGFloat(1)
            public var textHInset           = CGFloat(10)
            public var textVInset           = CGFloat(10)
            public var maxWidth             = CGFloat(200)
        }
        
        public var drawing      = Drawing()
        public var positioning  = Positioning()
        
        private var font : UIFont {
            if let font = self.drawing.font {
                return font
            }else{
                return UIFont.systemFontOfSize(self.drawing.systemFontSize)
            }
        }
        
        public init() {}
    }
    
    // MARK:- Variables -
    
    override public var backgroundColor : UIColor? {
        didSet {
            guard let color = backgroundColor
                where color != UIColor.clearColor() else {return}
            
            self.preferences.drawing.bubbleColor = color
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
    private let text                :   NSString
    
    // MARK: - Lazy variables -
    
    private lazy var textSize : CGSize = {
        
        [unowned self] in
        
        var attributes : [String : AnyObject] = [NSFontAttributeName : self.preferences.font]
        
        var textSize = self.text.boundingRectWithSize(CGSizeMake(self.preferences.positioning.maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        textSize.width = ceil(textSize.width)
        textSize.height = ceil(textSize.height)
        
        if textSize.width < self.preferences.drawing.arrowWidth {
            textSize.width = self.preferences.drawing.arrowWidth
        }
        
        return textSize
    }()
    
    private lazy var contentSize : CGSize = {
        
        [unowned self] in
        
        var contentSize = CGSizeMake(self.textSize.width + self.preferences.positioning.textHInset * 2 + self.preferences.positioning.bubbleHInset * 2, self.textSize.height + self.preferences.positioning.textVInset * 2 + self.preferences.positioning.bubbleVInset * 2 + self.preferences.drawing.arrowHeight)
        
        return contentSize
    }()
    
    // MARK: - Static variables -
    
    public static var globalPreferences = Preferences()
    
    // MARK:- Initializer -
    
    public init (text : NSString, preferences: Preferences = EasyTipView.globalPreferences, delegate : EasyTipViewDelegate? = nil){
        
        self.text = text
        self.preferences = preferences
        self.delegate = delegate
        
        super.init(frame : CGRectZero)
        
        self.backgroundColor = UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleRotation", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
    NSCoding not supported. Use init(text, preferences, delegate) instead!
    */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported. Use init(text, preferences, delegate) instead!")
    }
    
    // MARK: - Rotation support -
    
    func handleRotation () {
        guard let sview = self.superview
            where self.presentingView != nil else { return }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.arrangeInSuperview(sview)
            self.setNeedsDisplay()
        })
    }
    
    // MARK:- Class functions -
    
    public class func showAnimated(animated : Bool = true, forView view : UIView, withinSuperview superview : UIView? = nil, text :  NSString, preferences: Preferences = EasyTipView.globalPreferences, delegate : EasyTipViewDelegate? = nil){
        
        let ev = EasyTipView(text: text, preferences : preferences, delegate : delegate)
        
        ev.showForView(view, withinSuperview: superview, animated: animated)
    }
    
    public class func showAnimated(animated : Bool = true, forItem item : UIBarButtonItem, withinSuperview superview : UIView? = nil, text : NSString, preferences: Preferences = EasyTipView.globalPreferences, delegate : EasyTipViewDelegate? = nil){
        
        if let view = item.customView {
            self.showAnimated(animated, forView: view, withinSuperview: superview, text: text, preferences: preferences, delegate: delegate)
        }else{
            if let view = item.valueForKey("view") as? UIView {
                self.showAnimated(animated, forView: view, withinSuperview: superview, text: text, preferences: preferences, delegate: delegate)
            }
        }
    }
    
    // MARK:- Instance methods -
    
    public func showForItem(item : UIBarButtonItem, withinSuperView sview : UIView? = nil, animated : Bool = true) {
        if let view = item.customView {
            self.showForView(view, withinSuperview: sview, animated : animated)
        }else{
            if let view = item.valueForKey("view") as? UIView {
                self.showForView(view, withinSuperview: sview, animated: animated)
            }
        }
    }
    
    public func showForView(view : UIView, withinSuperview sview : UIView? = nil, animated : Bool = true) {
        
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
        
        let position = self.preferences.drawing.arrowPosition
        
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
                self.preferences.drawing.arrowPosition = .Bottom
                frame.origin.y = refViewOrigin.y - self.contentSize.height
            }
        }else{
            if CGRectGetMinY(frame) < 0 {
                self.preferences.drawing.arrowPosition = .Top
                frame.origin.y = refViewOrigin.y + refViewSize.height
            }
        }
        
        var arrowTipXOrigin : CGFloat
        
        if CGRectGetWidth(frame) < refViewSize.width {
            arrowTipXOrigin = self.contentSize.width / 2
        } else {
            arrowTipXOrigin = abs(frame.origin.x - refViewOrigin.x) + refViewSize.width / 2
        }
        
        self.arrowTip = CGPointMake(arrowTipXOrigin, self.preferences.drawing.arrowPosition == .Top ? self.preferences.positioning.bubbleVInset : self.contentSize.height - self.preferences.positioning.bubbleVInset)
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
        
        let bubbleWidth = self.contentSize.width - 2 * self.preferences.positioning.bubbleHInset
        let bubbleHeight = self.contentSize.height - 2 * self.preferences.positioning.bubbleVInset - self.preferences.drawing.arrowHeight
        let arrowWidth = self.preferences.drawing.arrowWidth
        let arrowHeight = self.preferences.drawing.arrowHeight
        let cornerRadius = self.preferences.drawing.bubbleCornerRadius
        let arrowPosition = self.preferences.drawing.arrowPosition
        let bubbleXOrigin = self.preferences.positioning.bubbleHInset
        let bubbleYOrigin = arrowPosition == .Bottom ? self.preferences.positioning.bubbleVInset : self.preferences.positioning.bubbleVInset + arrowHeight
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState (context)
        
        let contourPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(contourPath, nil, self.arrowTip.x, self.arrowTip.y)
        CGPathAddLineToPoint(contourPath, nil, self.arrowTip.x - arrowWidth / 2, self.arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * arrowHeight)
        
        if arrowPosition == .Top {
            
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin, bubbleXOrigin, bubbleYOrigin + bubbleHeight, cornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin + bubbleHeight, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, cornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, bubbleXOrigin + bubbleWidth, bubbleYOrigin, cornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin, bubbleXOrigin, bubbleYOrigin, cornerRadius)
            
        } else {
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin + bubbleHeight, bubbleXOrigin, bubbleYOrigin, cornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin, bubbleYOrigin, bubbleXOrigin + bubbleWidth, bubbleYOrigin, cornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, cornerRadius)
            CGPathAddArcToPoint(contourPath, nil, bubbleXOrigin + bubbleWidth, bubbleYOrigin + bubbleHeight, bubbleXOrigin, bubbleYOrigin + bubbleHeight, cornerRadius)
        }
        
        CGPathAddLineToPoint(contourPath, nil, self.arrowTip.x + arrowWidth / 2, self.arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * arrowHeight)
        
        CGPathCloseSubpath(contourPath)
        CGContextAddPath(context, contourPath)
        CGContextClip(context)
        
        CGContextSetFillColorWithColor(context, self.preferences.drawing.bubbleColor.CGColor)
        CGContextFillRect(context, self.bounds)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.preferences.drawing.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        let textRect = CGRectMake(bubbleXOrigin + (bubbleWidth - self.textSize.width) / 2, bubbleYOrigin + (bubbleHeight - self.textSize.height) / 2, textSize.width, textSize.height)
        
        
        self.text.drawInRect(textRect, withAttributes: [NSFontAttributeName : self.preferences.font, NSForegroundColorAttributeName : self.preferences.drawing.textColor, NSParagraphStyleAttributeName : paragraphStyle])
        
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