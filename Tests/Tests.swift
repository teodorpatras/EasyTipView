import UIKit
import XCTest
import EasyTipView
 
class Tests: XCTestCase {
    
    var view : UIView!
    var superview : UIView!
    
    override func setUp() {
        super.setUp()
        
        superview = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
        view = UIView(frame: CGRect(x: 0, y: 500, width: 100, height: 100))
        
        superview.addSubview(view)
    }
    
    func testViewPositionTop() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
        
        view.center = superview.center
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Top, "Position should be top")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(CGRectGetMinY(tipView.frame) == CGRectGetMaxY(view.frame), "EasyTipView should be below the presenting view")
    }
    
    func testViewPositionBottom() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Bottom
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Bottom, "Position should be bottom")
        XCTAssert(CGRectGetMaxY(tipView.frame) == CGRectGetMinY(view.frame), "EasyTipView should be above the presenting view")
    }
    
    func testViewPositionLeft() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = .Left
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Left, "Position should be left")
        XCTAssert(CGRectGetMinX(tipView.frame) == CGRectGetMaxX(view.frame), "EasyTipView should be to the right of the presenting view")
    }
    
    func testViewPositionRight() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = .Right
        
        view.frame = CGRectMake(superview.frame.size.width - 100, 0, 100, 100)
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Right, "Position should be right")
        XCTAssert(CGRectGetMaxX(tipView.frame) == CGRectGetMinX(view.frame), "EasyTipView should be to the right of the presenting view")
    }
    
    func testViewPositionAny() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = .Any
        
        view.center = superview.center
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Any, "Position should be any")
        XCTAssert(CGRectGetMinY(tipView.frame) == CGRectGetMaxY(view.frame), "EasyTipView should be below the presenting view")
    }
    
    func testAutoPositionAdjustmentAny() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = .Any
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Bottom, "Position should be bottom")
        XCTAssert(CGRectGetMaxY(tipView.frame) == CGRectGetMinY(view.frame), "EasyTipView should be above the presenting view")
    }
    
    func testAutoPositionAdjustmentTop() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Bottom, "Position should be bottom")
        XCTAssert(CGRectGetMaxY(tipView.frame) == CGRectGetMinY(view.frame), "EasyTipView should be above the presenting view")
    }
    
    func testAutoPositionAdjustmentRight() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = .Right
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Bottom, "Position should be bottom")
        XCTAssert(CGRectGetMaxY(tipView.frame) == CGRectGetMinY(view.frame), "EasyTipView should be above the presenting view")
    }
    
    func testAutoPositionAdjustmentLeft() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = .Left
        
        view.frame = CGRectMake(superview.frame.size.width - 100, superview.frame.size.height - 100, 100, 100)
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Bottom, "Position should be bottom")
        XCTAssert(CGRectGetMaxY(tipView.frame) == CGRectGetMinY(view.frame), "EasyTipView should be above the presenting view")
    }
    
    func testAutoPositionAdjustmentBottom() {
        
        var frame = view.frame
        frame.origin.y = 0
        
        view.frame = frame
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Bottom
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.preferences.drawing.arrowPosition == .Top, "Position should be bottom")
        XCTAssert(CGRectGetMinY(tipView.frame) == CGRectGetMaxY(view.frame), "EasyTipView should be below the presenting view")
    }
}
