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
            self.delegate?.easyTipViewDidDismiss(self)
            self.removeFromSuperview()
            self.transform = CGAffineTransformIdentity
        }
    }
}

// MARK: - EasyTipView class implementation -

public class EasyTipView: UIView {
    
    // MARK:- Nested types -
    
    public enum ArrowPosition {
        case Any
        case Top
        case Bottom
        case Right
        case Left
        
        static let allValues = [Top, Bottom, Right, Left]
    }
    
    public struct Preferences {
        
        public struct Drawing {
            public var cornerRadius        = CGFloat(5)
            public var arrowHeight         = CGFloat(5)
            public var arrowWidth          = CGFloat(10)
            public var foregroundColor     = UIColor.whiteColor()
            public var backgroundColor     = UIColor.redColor()
            public var arrowPosition       = ArrowPosition.Any
            public var textAlignment       = NSTextAlignment.Center
            public var borderWidth         = CGFloat(0)
            public var borderColor         = UIColor.clearColor()
            public var font                = UIFont.systemFontOfSize(15)
        }
        
        public struct Positioning {
            public var bubbleHInset         = CGFloat(1)
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
    
    private weak var presentingView             :   UIView?
    private weak var delegate                   :   EasyTipViewDelegate?
    private var arrowTip                        =   CGPointZero
    private(set) public var preferences         :   Preferences
    public let text                             :   String
    
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
    
    private func computeFrame(arrowPosition position: ArrowPosition, refViewFrame: CGRect, superviewFrame: CGRect) -> CGRect {
        var xOrigin: CGFloat = 0
        var yOrigin: CGFloat = 0
        
        switch position {
        case .Top, .Any:
            xOrigin = refViewFrame.center.x - contentSize.width / 2
            yOrigin = refViewFrame.y + refViewFrame.height
        case .Bottom:
            xOrigin = refViewFrame.center.x - contentSize.width / 2
            yOrigin = refViewFrame.y - contentSize.height
        case .Right:
            xOrigin = refViewFrame.x - contentSize.width
            yOrigin = refViewFrame.center.y - contentSize.height / 2
        case .Left:
            xOrigin = refViewFrame.x + refViewFrame.width
            yOrigin = refViewFrame.y - contentSize.height / 2
        }
        
        var frame = CGRectMake(xOrigin, yOrigin, contentSize.width, contentSize.height)
        adjustFrame(&frame, forSuperviewFrame: superviewFrame)
        return frame
    }
    
    private func adjustFrame(inout frame: CGRect, forSuperviewFrame superviewFrame: CGRect) {
        
        // adjust horizontally
        if frame.x < 0 {
            frame.x =  0
        } else if frame.maxX > superviewFrame.width {
            frame.x = superviewFrame.width - frame.width
        }
        
        //adjust vertically
        if frame.y < 0 {
            frame.y = 0
        } else if frame.maxY > superviewFrame.maxY {
            frame.y = superviewFrame.height - frame.height
        }
    }
    
    private func isFrameValid(frame: CGRect, forRefViewFrame: CGRect, withinSuperviewFrame: CGRect) -> Bool {
        return !CGRectIntersectsRect(frame, forRefViewFrame)
    }
    
    private func arrange(withinSuperview superview: UIView) {
        
        var position = preferences.drawing.arrowPosition
        
        let refViewFrame = presentingView!.convertRect(presentingView!.bounds, toView: superview);
        
        let superviewFrame: CGRect
        if let scrollview = superview as? UIScrollView {
          superviewFrame = CGRect(origin: scrollview.frame.origin, size: scrollview.contentSize)
        } else {
          superviewFrame = superview.frame
        }
        
        var frame = computeFrame(arrowPosition: position, refViewFrame: refViewFrame, superviewFrame: superviewFrame)
        
        if !isFrameValid(frame, forRefViewFrame: refViewFrame, withinSuperviewFrame: superviewFrame) {
            for value in ArrowPosition.allValues where value != position {
                let newFrame = computeFrame(arrowPosition: value, refViewFrame: refViewFrame, superviewFrame: superviewFrame)
                if isFrameValid(newFrame, forRefViewFrame: refViewFrame, withinSuperviewFrame: superviewFrame) {
                    
                    if position != .Any {
                        print("[EasyTipView - Info] The arrow position you chose <\(position)> could not be applied. Instead, position <\(value)> has been applied! Please specify position <\(ArrowPosition.Any)> if you want EasyTipView to choose a position for you.")
                    }
                    
                    frame = newFrame
                    position = value
                    preferences.drawing.arrowPosition = value
                    break
                }
            }
        }
        
        var arrowTipXOrigin: CGFloat
        
        switch position {
        case .Bottom, .Top, .Any:
            if CGRectGetWidth(frame) < refViewFrame.width {
                arrowTipXOrigin = contentSize.width / 2
            } else {
                arrowTipXOrigin = abs(frame.x - refViewFrame.x) + refViewFrame.width / 2
            }
            
            arrowTip = CGPointMake(arrowTipXOrigin, position == .Bottom ? contentSize.height - preferences.positioning.bubbleVInset :  preferences.positioning.bubbleVInset)
        case .Right, .Left:
            if CGRectGetHeight(frame) < refViewFrame.height {
                arrowTipXOrigin = contentSize.height / 2
            } else {
                arrowTipXOrigin = abs(frame.y - refViewFrame.y) + refViewFrame.height / 2
            }
            
            arrowTip = CGPointMake(preferences.drawing.arrowPosition == .Left ? preferences.positioning.bubbleVInset : contentSize.width - preferences.positioning.bubbleVInset, arrowTipXOrigin)
        }
        self.frame = frame
    }
    
    // MARK:- Callbacks -
    
    func handleTap() {
        dismiss()
    }
    
    // MARK:- Drawing -
    
    private func drawBubble(bubbleFrame: CGRect, arrowPosition: ArrowPosition,  context: CGContext) {
        
        let arrowWidth = preferences.drawing.arrowWidth
        let arrowHeight = preferences.drawing.arrowHeight
        let cornerRadius = preferences.drawing.cornerRadius
        
        let contourPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(contourPath, nil, arrowTip.x, arrowTip.y)
        
        switch arrowPosition {
        case .Bottom, .Top, .Any:
            
            CGPathAddLineToPoint(contourPath, nil, arrowTip.x - arrowWidth / 2, arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * arrowHeight)
            if arrowPosition == .Bottom {
                drawBubbleBottomShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            } else {
                drawBubbleTopShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            }
            CGPathAddLineToPoint(contourPath, nil, arrowTip.x + arrowWidth / 2, arrowTip.y + (arrowPosition == .Bottom ? -1 : 1) * arrowHeight)
            
        case .Right, .Left:
            
            CGPathAddLineToPoint(contourPath, nil, arrowTip.x + (arrowPosition == .Right ? -1 : 1) * arrowHeight, arrowTip.y - arrowWidth / 2)
            if arrowPosition == .Right {
                drawBubbleRightShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            } else {
                drawBubbleLeftShape(bubbleFrame, cornerRadius: cornerRadius, path: contourPath)
            }
            CGPathAddLineToPoint(contourPath, nil, arrowTip.x + (arrowPosition == .Right ? -1 : 1) * arrowHeight, arrowTip.y + arrowWidth / 2)
        }
        
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
    
    private func drawBubbleRightShape(frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y, frame.x, frame.y, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x, frame.y, frame.x, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x, frame.y + frame.height, frame.x + frame.width, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y + frame.height, frame.x + frame.width, frame.height, cornerRadius)
    }
    
    private func drawBubbleLeftShape(frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        CGPathAddArcToPoint(path, nil, frame.x, frame.y, frame.x + frame.width, frame.y, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y, frame.x + frame.width, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x + frame.width, frame.y + frame.height, frame.x, frame.y + frame.height, cornerRadius)
        CGPathAddArcToPoint(path, nil, frame.x, frame.y + frame.height, frame.x , frame.y, cornerRadius)
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
        let bubbleWidth: CGFloat
        let bubbleHeight: CGFloat
        let bubbleXOrigin: CGFloat
        let bubbleYOrigin: CGFloat
        switch arrowPosition {
        case .Bottom, .Top, .Any:
            
            bubbleWidth = contentSize.width - 2 * preferences.positioning.bubbleHInset
            bubbleHeight = contentSize.height - 2 * preferences.positioning.bubbleVInset - preferences.drawing.arrowHeight
            
            bubbleXOrigin = preferences.positioning.bubbleHInset
            bubbleYOrigin = arrowPosition == .Bottom ? preferences.positioning.bubbleVInset : preferences.positioning.bubbleVInset + preferences.drawing.arrowHeight
            
        case .Left, .Right:
            
            bubbleWidth = contentSize.width - 2 * preferences.positioning.bubbleHInset - preferences.drawing.arrowHeight
            bubbleHeight = contentSize.height - 2 * preferences.positioning.bubbleVInset
            
            bubbleXOrigin = arrowPosition == .Right ? preferences.positioning.bubbleHInset : preferences.positioning.bubbleHInset + preferences.drawing.arrowHeight
            bubbleYOrigin = preferences.positioning.bubbleVInset
            
        }
        let bubbleFrame = CGRectMake(bubbleXOrigin, bubbleYOrigin, bubbleWidth, bubbleHeight)
        
        let context = UIGraphicsGetCurrentContext()!
        CGContextSaveGState (context)
        
        drawBubble(bubbleFrame, arrowPosition: preferences.drawing.arrowPosition, context: context)
        drawText(bubbleFrame, context: context)
        
        CGContextRestoreGState(context)
    }
}
