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
    func easyTipViewDidDismiss(_ tipView : EasyTipView)
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
    public class func show(animated: Bool = true, forItem item: UIBarItem, withinSuperview superview: UIView? = nil, text: String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil){
        
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
    public class func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil, text:  String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil){
        
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
    public func show(animated: Bool = true, forItem item: UIBarItem, withinSuperView superview: UIView? = nil) {
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
    public func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil) {
        
        precondition(superview == nil || view.hasSuperview(superview!), "The supplied superview <\(superview!)> is not a direct nor an indirect superview of the supplied reference view <\(view)>. The superview passed to this method should be a direct or an indirect superview of the reference view. To display the tooltip within the main window, ignore the superview parameter.")
        
        let superview = superview ?? UIApplication.shared.windows.first!
        
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
            UIView.animate(withDuration: preferences.animating.showDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions(), animations: animations, completion: nil)
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
        
        UIView.animate(withDuration: preferences.animating.dismissDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions(), animations: { _ in
            self.transform = self.preferences.animating.dismissTransform
            self.alpha = self.preferences.animating.dismissFinalAlpha
        }) { (finished) -> Void in
            completion?()
            self.removeFromSuperview()
            self.transform = CGAffineTransform.identity
        }
    }
}

// MARK: - EasyTipView class implementation -

public class EasyTipView: UIView {
    
    // MARK:- Nested types -
    
    public enum ArrowPosition {
        case top
        case bottom
    }
    
    public struct Preferences {
        
        public struct Drawing {
            public var cornerRadius        = CGFloat(5)
            public var arrowHeight         = CGFloat(5)
            public var arrowWidth          = CGFloat(10)
            public var foregroundColor     = UIColor.white
            public var backgroundColor     = UIColor.red
            public var arrowPosition       = ArrowPosition.bottom
            public var textAlignment       = NSTextAlignment.center
            public var borderWidth         = CGFloat(0)
            public var borderColor         = UIColor.clear
            public var font                = UIFont.systemFont(ofSize: 15)
        }
        
        public struct Positioning {
            public var bubbleHInset         = CGFloat(10)
            public var bubbleVInset         = CGFloat(1)
            public var textHInset           = CGFloat(10)
            public var textVInset           = CGFloat(10)
            public var maxWidth             = CGFloat(200)
        }
        
        public struct Animating {
            public var dismissTransform     = CGAffineTransform(scaleX: 0.1, y: 0.1)
            public var showInitialTransform = CGAffineTransform(scaleX: 0, y: 0)
            public var showFinalTransform   = CGAffineTransform.identity
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
            return self.drawing.borderWidth > 0 && self.drawing.borderColor != .clear
        }
        
        public init() {}
    }
    
    // MARK:- Variables -
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard let color = backgroundColor, color != .clear else {return}
            
            self.preferences.drawing.backgroundColor = color
            backgroundColor = .clear
        }
    }
    
    override public var description: String {
        
        let type = "'\(String(reflecting: type(of: self)))'".components(separatedBy: ".").last!
        
        return "<< \(type) with text : '\(self.text)' >>"
    }
    
    fileprivate weak var presentingView :   UIView?
    private weak var delegate           :   EasyTipViewDelegate?
    private var arrowTip                =   CGPoint.zero
    fileprivate var preferences         :   Preferences
    public let text                     :   String
    
    // MARK: - Lazy variables -
    
    private lazy var textSize: CGSize = {
        
        [unowned self] in
        
        var attributes = [NSFontAttributeName : self.preferences.drawing.font]
        
        var textSize = self.text.boundingRect(with: CGSize(width: self.preferences.positioning.maxWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        textSize.width = ceil(textSize.width)
        textSize.height = ceil(textSize.height)
        
        if textSize.width < self.preferences.drawing.arrowWidth {
            textSize.width = self.preferences.drawing.arrowWidth
        }
        
        return textSize
        }()
    
    private lazy var contentSize: CGSize = {
        
        [unowned self] in
        
        var contentSize = CGSize(width: self.textSize.width + self.preferences.positioning.textHInset * 2 + self.preferences.positioning.bubbleHInset * 2, height: self.textSize.height + self.preferences.positioning.textVInset * 2 + self.preferences.positioning.bubbleVInset * 2 + self.preferences.drawing.arrowHeight)
        
        return contentSize
        }()
    
    // MARK: - Static variables -
    
    public static var globalPreferences = Preferences()
    
    // MARK:- Initializer -
    
    public init (text: String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil){
        
        self.text = text
        self.preferences = preferences
        self.delegate = delegate
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     NSCoding not supported. Use init(text, preferences, delegate) instead!
     */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported. Use init(text, preferences, delegate) instead!")
    }
    
    // MARK: - Rotation support -
    
    func handleRotation() {
        guard let sview = self.superview, self.presentingView != nil else { return }
        
        UIView.animate(withDuration: 0.3, animations: { _ in
            self.arrange(withinSuperview: sview)
            self.setNeedsDisplay()
        })
    }
    
    // MARK: - Private methods -
    
    fileprivate func arrange(withinSuperview superview: UIView) {
        
        let position = preferences.drawing.arrowPosition
        
        let refViewOrigin = presentingView!.originWithinDistantSuperView(superview)
        let refViewSize = presentingView!.frame.size
        let refViewCenter = CGPoint(x: refViewOrigin.x + refViewSize.width / 2, y: refViewOrigin.y + refViewSize.height / 2)
        
        let xOrigin = refViewCenter.x - contentSize.width / 2
        let yOrigin = position == .bottom ? refViewOrigin.y - contentSize.height : refViewOrigin.y + refViewSize.height
        
        var frame = CGRect(x: xOrigin, y: yOrigin, width: contentSize.width, height: contentSize.height)
        
        if frame.origin.x < 0 {
            frame.origin.x =  0
        } else if frame.maxX > superview.frame.width{
            frame.origin.x = superview.frame.width - frame.width
        }
        
        if position == .top {
            if frame.maxY > superview.frame.height{
                preferences.drawing.arrowPosition = .bottom
                frame.origin.y = refViewOrigin.y - contentSize.height
            }
        }else{
            if frame.minY < 0 {
                preferences.drawing.arrowPosition = .top
                frame.origin.y = refViewOrigin.y + refViewSize.height
            }
        }
        
        var arrowTipXOrigin: CGFloat
        
        if frame.width < refViewSize.width {
            arrowTipXOrigin = contentSize.width / 2
        } else {
            arrowTipXOrigin = abs(frame.origin.x - refViewOrigin.x) + refViewSize.width / 2
        }
        
        arrowTip = CGPoint(x: arrowTipXOrigin, y: preferences.drawing.arrowPosition == .top ? self.preferences.positioning.bubbleVInset : contentSize.height - preferences.positioning.bubbleVInset)
        self.frame = frame
    }
    
    // MARK:- Callbacks -
    
    func handleTap() {
        dismiss {
            self.delegate?.easyTipViewDidDismiss(self)
        }
    }
    
    // MARK:- Drawing -
    
    private func drawBubble(_ bubbleFrame: CGRect, arrowPosition: ArrowPosition,  context: CGContext) {
        
        let arrowWidth = preferences.drawing.arrowWidth
        let arrowHeight = preferences.drawing.arrowHeight
        let cornerRadius = preferences.drawing.cornerRadius
        
        let contourPath = CGMutablePath()
        contourPath.move(to: CGPoint(x: arrowTip.x, y: arrowTip.y))
        contourPath.addLine(to: CGPoint(x: arrowTip.x - arrowWidth / 2, y: arrowTip.y + (arrowPosition == .bottom ? -1 : 1) * arrowHeight))
        
        var method = drawBubbleTopShape
        
        if arrowPosition == .bottom {
            method = drawBubbleBottomShape
        }
        
        method(bubbleFrame, cornerRadius, contourPath)
        
        contourPath.addLine(to: CGPoint(x: arrowTip.x + arrowWidth / 2, y: arrowTip.y + (arrowPosition == .bottom ? -1 : 1) * arrowHeight))
        
        contourPath.closeSubpath()
        context.addPath(contourPath)
        context.clip()
        
        paintBubble(context)
        
        if preferences.hasBorder {
            drawBorder(contourPath, context: context)
        }
    }
    
    private func drawBubbleBottomShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        let points = [
            (CGPoint(x: frame.x, y: frame.maxY), CGPoint(x: frame.x, y: frame.y)),
            (CGPoint(x: frame.x, y: frame.y), CGPoint(x: frame.maxX, y: frame.y)),
            (CGPoint(x: frame.maxX, y: frame.y), CGPoint(x: frame.maxX, y: frame.maxY)),
            (CGPoint(x: frame.maxX, y: frame.maxY), CGPoint(x: frame.x, y: frame.maxY)),
            ]
        
        addArcs(to: points, cornerRadius: cornerRadius, path: path)
    }
    
    private func drawBubbleTopShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        let points = [
            (CGPoint(x: frame.x, y: frame.y), CGPoint(x: frame.x, y: frame.maxY)),
            (CGPoint(x: frame.x, y: frame.maxY), CGPoint(x: frame.maxX, y: frame.maxY)),
            (CGPoint(x: frame.maxX, y: frame.maxY), CGPoint(x: frame.maxX, y: frame.y)),
            (CGPoint(x: frame.maxX, y: frame.y), CGPoint(x: frame.x, y: frame.y)),
            ]
        
        addArcs(to: points, cornerRadius: cornerRadius, path: path)
    }
    
    private func addArcs(to points: [(CGPoint, CGPoint)], cornerRadius: CGFloat, path: CGMutablePath) {
        for tangentPoints in points {
            path.addArc(tangent1End: tangentPoints.0, tangent2End: tangentPoints.1, radius: cornerRadius)
        }
    }
    
    private func paintBubble(_ context: CGContext) {
        context.setFillColor(preferences.drawing.backgroundColor.cgColor)
        context.fill(self.bounds)
    }
    
    private func drawBorder(_ borderPath: CGPath, context: CGContext) {
        context.addPath(borderPath)
        context.setStrokeColor(preferences.drawing.borderColor.cgColor)
        context.setLineWidth(preferences.drawing.borderWidth)
        context.strokePath()
    }
    
    private func drawText(_ bubbleFrame: CGRect, context : CGContext) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = preferences.drawing.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        let textRect = CGRect(x: bubbleFrame.origin.x + (bubbleFrame.size.width - textSize.width) / 2, y: bubbleFrame.origin.y + (bubbleFrame.size.height - textSize.height) / 2, width: textSize.width, height: textSize.height)
        
        
        text.draw(in: textRect, withAttributes: [NSFontAttributeName : preferences.drawing.font, NSForegroundColorAttributeName : preferences.drawing.foregroundColor, NSParagraphStyleAttributeName : paragraphStyle])
    }
    
    override public func draw(_ rect: CGRect) {
        
        let arrowPosition = preferences.drawing.arrowPosition
        let bubbleWidth = contentSize.width - 2 * preferences.positioning.bubbleHInset
        let bubbleHeight = contentSize.height - 2 * preferences.positioning.bubbleVInset - preferences.drawing.arrowHeight
        let bubbleXOrigin = preferences.positioning.bubbleHInset
        let bubbleYOrigin = arrowPosition == .bottom ? preferences.positioning.bubbleVInset : preferences.positioning.bubbleVInset + preferences.drawing.arrowHeight
        let bubbleFrame = CGRect(x: bubbleXOrigin, y: bubbleYOrigin, width: bubbleWidth, height: bubbleHeight)
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState ()
        
        drawBubble(bubbleFrame, arrowPosition: preferences.drawing.arrowPosition, context: context)
        drawText(bubbleFrame, context: context)
        
        context.restoreGState()
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
        return self.value(forKey: "view") as? UIView
    }
}

// MARK:- UIView extension -

private extension UIView {
    
    func originWithinDistantSuperView(_ superview: UIView?) -> CGPoint
    {
        if self.superview != nil {
            return viewOriginInSuperview(self.superview!, subviewOrigin: self.frame.origin, refSuperview : superview)
        }else{
            return self.frame.origin
        }
    }
    
    func hasSuperview (_ superview: UIView) -> Bool{
        return viewHasSuperview(self, superview: superview)
    }
    
    private func viewHasSuperview (_ view: UIView, superview: UIView) -> Bool {
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
    
    private func viewOriginInSuperview(_ sview: UIView, subviewOrigin sorigin: CGPoint, refSuperview: UIView?) -> CGPoint {
        
        if let superview = sview.superview {
            if let ref = refSuperview {
                if sview === ref {
                    return sorigin
                }else{
                    return viewOriginInSuperview(superview, subviewOrigin: CGPoint(x: sview.frame.origin.x + sorigin.x, y: sview.frame.origin.y + sorigin.y), refSuperview: ref)
                }
            }else{
                return viewOriginInSuperview(superview, subviewOrigin: CGPoint(x: sview.frame.origin.x + sorigin.x, y: sview.frame.origin.y + sorigin.y), refSuperview: nil)
            }
        }else{
            return CGPoint(x: sview.frame.origin.x + sorigin.x, y: sview.frame.origin.y + sorigin.y)
        }
    }
}
