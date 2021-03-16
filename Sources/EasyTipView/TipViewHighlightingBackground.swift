//
//  TipViewHighlightingBackground.swift
//  EasyTipView
//
//  Created by Jan Lottermoser on 11.03.21.
//  Copyright © 2021 teodorpatras. All rights reserved.
//

import UIKit

public final class TipViewHighlightingBackground: UIView {
    
    // MARK: - Public interface
    
    /// The view around which the highlighting will be shown
    public var viewToHighlight: UIView?
    
    /// A closure to execute when the view is tapped
    public var tapAction: (() -> Void)?

    /// The default margin of the highlighting circle to the frame of `viewToHighlight.
    /// This property only takes effect if `circleRadius` is nil.
    public var circleMargin: CGFloat = 4
    
    /// The radius of the highlighting circle.
    /// If this property has a non-nil value the `circleMargin` property is ignored.
    public var circleRadius: CGFloat?
    
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
        
        let viewFrame = viewToHighlight.superview?.convert(viewToHighlight.frame, to: self) ?? .zero
        let width = viewFrame.width / 2
        let height = viewFrame.height / 2
        let radius = ((width * width) + (height * height)).squareRoot()

        path.addArc(center: viewFrame.center,
                    radius: circleRadius ?? radius + circleMargin,
                    startAngle: 0,
                    endAngle: 2 * CGFloat.pi,
                    clockwise: true)
        
        path.addRect(bounds)
        
        mask.path = path
        mask.fillRule = .evenOdd
        self.layer.mask = mask
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
}
