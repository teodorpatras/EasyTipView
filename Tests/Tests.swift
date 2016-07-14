import UIKit
import XCTest
import EasyTipView
 
class Tests: XCTestCase {
    
    var view : UIView!
    var superview : UIView!
    
    override func setUp() {
        super.setUp()
        
        superview = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
        view = UIView(frame: CGRect(x: 0, y: 520, width: 100, height: 80))
        
        superview.addSubview(view)
    }
    
    func testViewPositionTop() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        view.center = superview.center
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.frame.minY == view.frame.maxY, "EasyTipView should be below the presenting view")
    }
    
    func testViewPositionBottom() {
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.frame.maxY == view.frame.minY, "EasyTipView should be above the presenting view")
    }
    
    func testAutoPositionAdjustmentTop() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.frame.maxY == view.frame.minY, "EasyTipView should be above the presenting view")
    }
    
    func testAutoPositionAdjustmentBottom() {
        
        var frame = view.frame
        frame.origin.y = 0
        
        view.frame = frame
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        
        let tipView = EasyTipView(text: "Some text", preferences: preferences)
        tipView.show(animated: false, forView: view, withinSuperview: superview)
        
        XCTAssert(tipView.superview === superview, "EasyTipView should be present")
        XCTAssert(tipView.alpha == 1, "EasyTipView should be visible")
        XCTAssert(tipView.frame.minY == view.frame.maxY, "EasyTipView should be below the presenting view")
    }
}
