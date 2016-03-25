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


// MARK: - Public methods extension

public extension EasyTipView {
    
    // MARK:- Class methods -
    
    /**
    Presents an EasyTipView pointing to a particular UIBarItem instance within the specified superview
    
    - parameter animated:    Pass true to animate the presentation.
    - parameter item:        The UIBarButtonItem or UITabBarItem instance which the EasyTipView will be pointing to.
    - parameter superview:   A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
    - parameter text:        The text to be displayed.
    - parameter preferences: The preferences which will configure the EasyTipView.
    - parameter delegate:    The delegate.
    */
    public class func show(animated animated: Bool = true, forItem item: UIBarItem, withinSuperview superview: UIView? = nil, text: String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil){
        
        if let view = item.view {
            show(animated: animated, forView: view, withinSuperview: superview, text: text, preferences: preferences, delegate: delegate)
        }
    }
    
    /**
     Presents an EasyTipView pointing to a particular UIView instance within the specified superview
    
     - parameter animated:    Pass true to animate the presentation.
     - parameter view:        The UIView instance which the EasyTipView will be pointing to.
     - parameter superview:   A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
     - parameter text:        The text to be displayed.
     - parameter preferences: The preferences which will configure the EasyTipView.
     - parameter delegate:    The delegate.
    */
    public class func show(animated animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil, text:  String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil){
        
        let ev = EasyTipView(text: text, preferences: preferences, delegate: delegate)
        ev.show(animated: animated, forView: view, withinSuperview: superview)
    }
    
    // MARK:- Instance methods -
    
    /**
    Presents an EasyTipView pointing to a particular UIBarItem instance within the specified superview
    
    - parameter animated:  Pass true to animate the presentation.
    - parameter item:      The UIBarButtonItem or UITabBarItem instance which the EasyTipView will be pointing to.
    - parameter superview: A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
    */
    public func show(animated animated: Bool = true, forItem item: UIBarItem, withinSuperView superview: UIView? = nil) {
        if let view = item.view {
            show(animated: animated, forView: view, withinSuperview: superview)
        }
    }
    
    /**
     Presents an EasyTipView pointing to a particular UIView instance within the specified superview
     
     - parameter animated:  Pass true to animate the presentation.
     - parameter view:      The UIView instance which the EasyTipView will be pointing to.
     - parameter superview: A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
     */
    public func show(animated animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil) {
        
        precondition(superview == nil || view.hasSuperview(superview!), "The supplied superview <\(superview!)> is not a direct nor an indirect superview of the supplied reference view <\(view)>. The superview passed to this method should be a direct or an indirect superview of the reference view. To display the tooltip within the main window, ignore the superview parameter.")
        
        let superview = superview ?? UIApplication.sharedApplication().windows.first!
        
        let initialTransform = preferences.animating.showInitialTransform
        let finalTransform = preferences.animating.showFinalTransform
        let initialAlpha = preferences.animating.showInitialAlpha
        let damping = preferences.animating.springDamping
        let velocity = preferences.animating.springVelocity
        
        presentingView = view
        arrange(withinSuperview: superview)
        
        transform = initialTransform
        alpha = initialAlpha
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        
        superview.addSubview(self)
        
        let animations : () -> () = {
            self.transform = finalTransform
            self.alpha = 1
        }
        
        if animated {
            UIView.animateWithDuration(preferences.animating.showDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    /**
     Dismisses the EasyTipView
     
     - parameter completion: Completion block to be executed after the EasyTipView is dismissed.
     */
    public func dismiss(withCompletion completion: (() -> ())? = nil){
        
        let damping = preferences.animating.springDamping
        let velocity = preferences.animating.springVelocity
        
        UIView.animateWithDuration(preferences.animating.dismissDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { _ in
            self.transform = self.preferences.animating.dismissTransform
            self.alpha = self.preferences.animating.dismissFinalAlpha
        }) { (finished) -> Void in
            completion?()
            self.removeFromSuperview()
        }
    }
}

// MARK: - EasyTipView class implementation -

public class EasyTipView: UIView {
    
    // MARK:- Nested types -
    
    public enum ArrowPosition {
        case Top
        case Bottom
    }
    
    public struct Preferences {
        
        public struct Drawing {
            public var cornerRadius        = CGFloat(5)
            public var arrowHeight         = CGFloat(5)
            public var arrowWidth          = CGFloat(10)
            public var foregroundColor     = UIColor.whiteColor()
            public var backgroundColor     = UIColor.redColor()
            public var arrowPosition       = ArrowPosition.Bottom
            public var textAlignment       = NSTextAlignment.Center
            public var borderWidth         = CGFloat(0)
            public var borderColor         = UIColor.clearColor()
            public var font                = UIFont.systemFontOfSize(15)
        }
        
        public struct Positioning {
            public var bubbleHInset         = CGFloat(10)
            public var bubbleVInset         = CGFloat(1)
            public var textHInset           = CGFloat(10)
            public var textVInset           = CGFloat(10)
            public var maxWidth             = CGFloat(200)
        }
        
        public struct Animating {
            public var dismissTransform     = CGAffineTransformMakeScale(0.1, 0.1)
            public var showInitialTransform = CGAffineTransformMakeScale(0, 0)
            public var showFinalTransform   = CGAffineTransformIdentity
            public var springDamping        = CGFloat(0.7)
            public var springVelocity       = CGFloat(0.7)
            public var showInitialAlpha     = CGFloat(0)
            public var dismissFinalAlpha    = CGFloat(0)
            public var showDuration         = 0.7
            public var dismissDuration      = 0.7
        }
        
        public var drawing      = Drawing()
        public var positioning  = Positioning()
        public var animating    = Animating()
        public var hasBorder : Bool {
            return self.drawing.borderWidth > 0 && self.drawing.borderColor != UIColor.clearColor()
        }
        
        public init() {}
    }
    
    // MARK:- Variables -
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard let color = backgroundColor
                where color != UIColor.clearColor() else {return}
            
            self.preferences.drawing.backgroundColor = color
            backgroundColor = UIColor.clearColor()
        }
    }
    
    override public var description: String {

        let type = "'\(String(reflecting: self.dynamicType))'".componentsSeparatedByString(".").last!
        
        return "<< \(type) with text : '\(self.text)' >>"
    }
    
    private weak var presentingView :   UIView?
    private weak var delegate       :   EasyTipViewDelegate?
    private var arrowTip            =   CGPointZero
    private var preferences         :   Preferences
    public let text                 :   String
    
    // MARK: - Lazy variables -
    
    private lazy var textSize: CGSize = {
        
        [unowned self] in
        
        var attributes = [NSFontAttributeName : self.preferences.drawing.font]
        
        var textSize = self.text.boundingRectWithSize(CGSizeMake(self.preferences.positioning.maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        textSize.width = ceil(textSize.width)
        textSize.height = ceil(textSize.height)
        
        if textSize.width < self.preferences.drawing.arrowWidth {
            textSize.width = self.preferences.drawing.arrowWidth
        }
        
        return textSize
        }()
    
    private lazy var contentSize: CGSize = {
        
        [unowned self] in
        
        var contentSize = CGSizeMake(self.textSize.width + self.preferences.positioning.textHInset * 2 + self.preferences.positioning.bubbleHInset * 2, self.textSize.height + self.preferences.positioning.textVInset * 2 + self.preferences.positioning.bubbleVInset * 2 + self.preferences.drawing.arrowHeight)
        
        return contentSize
        }()
    
    // MARK: - Static variables -
    
    public static var globalPreferences = Preferences()
    
    // MARK:- Initializer -
    
    public init (text: String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil){
        
        self.text = text
        self.preferences = preferences
        self.delegate = delegate
        
        super.init(frame: CGRectZero)
        
        self.backgroundColor = UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleRotation), name: UIDeviceOrientationDidChangeNotification, object: nil)
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
    
    func handleRotation() {
        guard let sview = self.superview
            where self.presentingView != nil else { return }
        
        UIView.animateWithDuration(0.3, animations: { _ in
            self.arrange(withinSuperview: sview)
            self.setNeedsDisplay()
        })
    }
    
    // MARK: - Private methods -
    
    private func arrange(withinSuperview superview: UIView) {
        
        let position = preferences.drawing.arrowPosition
        
        let refViewOrigin = presentingView!.originWithinDistantSuperView(superview)
        let refViewSize = presentingView!.frame.size
        let refViewCenter = CGPointMake(refViewOrigin.x + refViewSize.width / 2, refViewOrigin.y + refViewSize.height / 2)
        
        let xOrigin = refViewCenter.x - contentSize.width / 2
        let yOrigin = position == .Bottom ? refViewOrigin.y - contentSize.height : refViewOrigin.y + refViewSize.height
        
        var frame = CGRectMake(xOrigin, yOrigin, contentSize.width, contentSize.height)
        
        if frame.origin.x < 0 {
            frame.origin.x =  0
        } else if CGRectGetMaxX(frame) > CGRectGetWidth(superview.frame){
            frame.origin.x = superview.frame.width - CGRectGetWidth(frame)
        }
        
        if position == .Top {
            if CGRectGetMaxY(frame) > CGRectGetHeight(superview.frame){
                preferences.drawing.arrowPosition = .Bottom
                frame.origin.y = refViewOrigin.y - contentSize.height
            }
        }else{
            if CGRectGetMinY(frame) < 0 {
                preferences.drawing.arrowPosition = .Top
                frame.origin.y = refViewOrigin.y + refViewSize.height
            }
        }
        
        var arrowTipXOrigin: CGFloat
        
        if CGRectGetWidth(frame) < refViewSize.width {
            arrowTipXOrigin = contentSize.width / 2
        } else {
            arrowTipXOrigin = abs(frame.origin.x - refViewOrigin.x) + refViewSize.width / 2
        }
        
        arrowTip = CGPointMake(arrowTipXOrigin, preferences.drawing.arrowPosition == .Top ? self.preferences.positioning.bubbleVInset : contentSize.height - preferences.positioning.bubbleVInset)
        self.frame = frame
    }
    
    // MARK:- Callbacks -
    
    func handleTap() {
        dismiss {
            self.delegate?.easyTipViewDidDismiss(self)
        }
    }
    
    // MARK:- Drawing -
    
    private func drawBubble(bubbleFrame: CGRect, arrowPosition: ArrowPosition,  context: CGContext) {
        
        let arrowWidth = preferences.drawing.arrowWidth
        let arrowHeight = preferences.drawing.arrowHeight
        let cornerRadius = preferences.drawing.cornerRadius
        
        let contourPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(contourPath, nil, arrowTip.x, arrowTip.y)
        CGPathAddLineToPoint(contourPath, nil, arrowTip.x - arrowWidth / 2, arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * arrowHeight)
        
        var method = drawBubbleTopShape
        
        if arrowPosition == .Bottom {
            method = drawBubbleBottomShape
        }
        
        method(bubbleFrame, cornerRadius : cornerRadius, path : contourPath)
        
        CGPathAddLineToPoint(contourPath, nil, arrowTip.x + arrowWidth / 2, arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * arrowHeight)
        
        CGPathCloseSubpath(contourPath)
        CGContextAddPath(context, contourPath)
        CGContextClip(context)
        
        paintBubble(context)
        
        if preferences.hasBorder {
            drawBorder(contourPath, context: context)
        }
    }
    
    private func drawBubbleBottomShape(frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        CGPathAddArcToPoint(path, nil, frame.x, frame.y + frame.height, frame.x, frame.y, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x, frame.y, frame.x + frame.width, frame.y, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y, frame.x + frame.width, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y + frame.height, frame.x, frame.y + frame.height, cornerRadius)
    }
    
    private func drawBubbleTopShape(frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        CGPathAddArcToPoint(path, nil, frame.x, frame.y, frame.x, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x, frame.y + frame.height, frame.x + frame.width, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y + frame.height, frame.x + frame.width, frame.y, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y, frame.x, frame.y, cornerRadius)
    }
    
    private func paintBubble(context: CGContext) {
        CGContextSetFillColorWithColor(context, preferences.drawing.backgroundColor.CGColor)
        CGContextFillRect(context, self.bounds)
    }
    
    private func drawBorder(borderPath: CGPath, context: CGContext) {
        CGContextAddPath(context, borderPath)
        CGContextSetStrokeColorWithColor(context, preferences.drawing.borderColor.CGColor)
        CGContextSetLineWidth(context, preferences.drawing.borderWidth)
        CGContextStrokePath(context)
    }
    
    private func drawText(bubbleFrame: CGRect, context : CGContext) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = preferences.drawing.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        let textRect = CGRectMake(bubbleFrame.origin.x + (bubbleFrame.size.width - textSize.width) / 2, bubbleFrame.origin.y + (bubbleFrame.size.height - textSize.height) / 2, textSize.width, textSize.height)
        
        
        text.drawInRect(textRect, withAttributes: [NSFontAttributeName : preferences.drawing.font, NSForegroundColorAttributeName : preferences.drawing.foregroundColor, NSParagraphStyleAttributeName : paragraphStyle])
    }
    
    override public func drawRect(rect: CGRect) {
        
        let arrowPosition = preferences.drawing.arrowPosition
        let bubbleWidth = contentSize.width - 2 * preferences.positioning.bubbleHInset
        let bubbleHeight = contentSize.height - 2 * preferences.positioning.bubbleVInset - preferences.drawing.arrowHeight
        let bubbleXOrigin = preferences.positioning.bubbleHInset
        let bubbleYOrigin = arrowPosition == .Bottom ? preferences.positioning.bubbleVInset : preferences.positioning.bubbleVInset + preferences.drawing.arrowHeight
        let bubbleFrame = CGRectMake(bubbleXOrigin, bubbleYOrigin, bubbleWidth, bubbleHeight)
        
        let context = UIGraphicsGetCurrentContext()!
        CGContextSaveGState (context)
        
        drawBubble(bubbleFrame, arrowPosition: preferences.drawing.arrowPosition, context: context)
        drawText(bubbleFrame, context: context)
        
        CGContextRestoreGState(context)
    }
}

// MARK:- CGRect extension -

private extension CGRect {
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

// MARK: - UIBarItem extension -

private extension UIBarItem {
    var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.valueForKey("view") as? UIView
    }
}

// MARK:- UIView extension -

private extension UIView {
    
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