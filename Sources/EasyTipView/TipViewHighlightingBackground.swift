//
//  TipViewHighlightingBackground.swift
//  EasyTipView
//
//  Created by Jan Lottermoser on 11.03.21.
//  Copyright © 2021 teodorpatras. All rights reserved.
//

import UIKit

final class TipViewHighlightingBackground: UIView {
    
    // MARK: - Public interface
    
    /// The view around which the highlighting will be shown
    var viewToHighlight: UIView?
    
    /// A closure to execute when the view is tapped
    var tapAction: (() -> Void)?

    /// The default margin of the highlighting circle to the frame of `viewToHighlight.
    /// This property only takes effect if `circleRadius` is nil.
    var circleMargin: CGFloat = 4
    
    /// The radius of the highlighting circle.
    /// If this property has a non-nil value the `circleMargin` property is ignored.
    var circleRadius: CGFloat?
    
    /// The background color of the highlighting circle.
    /// If this property is nil the backgound will not be colored differently.
    var highlightingBackground: UIColor?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentMode = .redraw
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - User input
    @objc private func handleTap() {
        tapAction?()
    }
    
    // MARK: - Drawing and layout
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let viewToHighlight = viewToHighlight else { return }
        
        // add a mask with a cicle hole in the position of the viewToHighlight
        let mask = CAShapeLayer()
        let path = CGMutablePath()
        
        // for the radius of the circle either take the provided `circleRadius` value
        // or compute a radius so the circle has `circleMargin` distance from the corner of the view
        let viewFrame = viewToHighlight.superview?.convert(viewToHighlight.frame, to: self) ?? .zero
        let width = viewFrame.width / 2
        let height = viewFrame.height / 2
        let distanceToEdge = ((width * width) + (height * height)).squareRoot()
        let radius = circleRadius ?? distanceToEdge + circleMargin

        path.addArc(center: viewFrame.center,
                    radius: radius,
                    startAngle: 0,
                    endAngle: 2 * CGFloat.pi,
                    clockwise: true)
        
        path.addRect(bounds)
        
        mask.path = path
        mask.fillRule = .evenOdd
        self.layer.mask = mask
        
        addCircleBackground(radius: radius)
    }
    
    private lazy var circleBackground = UIView()
    
    private func addCircleBackground(radius: CGFloat) {
        guard let color = highlightingBackground, let viewToHighlight = viewToHighlight else { return }
        
        circleBackground.bounds = CGRect(origin: .zero, size: CGSize(width: 2 * radius, height: 2 * radius))
        circleBackground.center = viewToHighlight.center
        
        let mask = CAShapeLayer()
        let path = CGMutablePath()

        path.addEllipse(in: circleBackground.bounds)
        mask.path = path
        mask.fillRule = .evenOdd
        circleBackground.layer.mask = mask
        
        circleBackground.backgroundColor = color
        
        if circleBackground.superview == nil {
            viewToHighlight.superview?.insertSubview(circleBackground, belowSubview: viewToHighlight)
        }
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        circleBackground.removeFromSuperview()
    }
    
    override var alpha: CGFloat {
        didSet {
            circleBackground.alpha = alpha
        }
    }
}
