//
// ViewController.swift
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
import Darwin
import EasyTipView

class ViewController: UIViewController, EasyTipViewDelegate {
    
    @IBOutlet weak var toolbarItem: UIBarButtonItem!
    @IBOutlet weak var smallContainerView: UIView!
    @IBOutlet weak var navBarItem: UIBarButtonItem!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var buttonE: UIButton!
    @IBOutlet weak var buttonF: UIButton!
    
    weak var tipView: EasyTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        
        EasyTipView.globalPreferences = preferences
        self.view.backgroundColor = UIColor(hue:0.75, saturation:0.01, brightness:0.96, alpha:1.00)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.toolbarItemAction()
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        print("\(tipView) did dismiss!")
    }
    
    @IBAction func barButtonAction(sender: UIBarButtonItem) {
        let text = "Tip view for bar button item displayed within the navigation controller's view. Tap to dismiss."
        EasyTipView.show(forItem: self.navBarItem,
            withinSuperview: self.navigationController?.view,
            text: text,
            delegate : self)
    }
    
    @IBAction func toolbarItemAction() {
        if let tipView = tipView {
            tipView.dismiss(withCompletion: { 
                print("Completion called!")
            })
        } else {
            let text = "EasyTipView is an easy to use tooltip view. It can point to any UIView or UIBarItem subclasses. Tap the buttons to see other tooltips."
            let tip = EasyTipView(text: text, delegate: self)
            tip.show(forItem: toolbarItem)
            tipView = tip
        }
    }
    
    @IBAction func buttonAction(sender : UIButton) {
        switch sender {
        case buttonA:
            
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = UIColor(hue:0.58, saturation:0.1, brightness:1, alpha:1)
            preferences.drawing.foregroundColor = UIColor.darkGray
            preferences.drawing.textAlignment = NSTextAlignment.center
            
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 100, y: 0)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: -100, y: 0)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 1
            preferences.animating.dismissDuration = 1
            
            let view = EasyTipView(text: "Tip view within the green superview. Tap to dismiss.", preferences: preferences)
            view.show(forView: buttonA, withinSuperview: self.smallContainerView)
            
        case buttonB:
            
            var preferences = EasyTipView.globalPreferences
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.font = UIFont(name: "HelveticaNeue-Light", size: 14)!
            preferences.drawing.textAlignment = NSTextAlignment.justified
            
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 1
            preferences.animating.dismissDuration = 1
            preferences.drawing.arrowPosition = .top
            
            let text = "Tip view inside the navigation controller's view. Tap to dismiss!"
            EasyTipView.show(forView: self.buttonB,
                withinSuperview: self.navigationController?.view,
                text: text,
                preferences: preferences)
            
        case buttonC:
            
            var preferences = EasyTipView.globalPreferences
            preferences.drawing.backgroundColor = buttonC.backgroundColor!
            
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 1.5
            preferences.animating.dismissDuration = 1.5
            preferences.drawing.arrowPosition = .top
            
            let text = "This tip view cannot be presented with the arrow on the top position, so position bottom has been chosen instead. Tap to dismiss."
            EasyTipView.show(forView: buttonC,
                withinSuperview: navigationController?.view,
                text: text,
                preferences: preferences)
            
        case buttonE:
            
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = buttonE.backgroundColor!
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.textAlignment = NSTextAlignment.center
            
            preferences.drawing.arrowPosition = .right
            
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 100)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -100)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 1
            preferences.animating.dismissDuration = 1
            
            preferences.positioning.maxWidth = 150
            
            let view = EasyTipView(text: "Tip view positioned with the arrow on the right. Tap to dismiss.", preferences: preferences)
            view.show(forView: buttonE, withinSuperview: self.navigationController?.view!)
            
        case buttonF:
            
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = buttonF.backgroundColor!
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.textAlignment = NSTextAlignment.center
            
            preferences.drawing.arrowPosition = .left
            
            preferences.animating.dismissTransform = CGAffineTransform(translationX: -30, y: -100)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: 30, y: 100)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 1
            preferences.animating.dismissDuration = 1
            
            preferences.positioning.maxWidth = 150
            
            let view = EasyTipView(text: "Tip view positioned with the arrow on the left. Tap to dismiss.", preferences: preferences)
            view.show(forView: buttonF, withinSuperview: self.navigationController?.view!)
            
        default:
            
            var preferences = EasyTipView.globalPreferences
            preferences.drawing.arrowPosition = .bottom
            preferences.drawing.font = UIFont.systemFont(ofSize: 14)
            preferences.drawing.textAlignment = .center
            preferences.drawing.backgroundColor = buttonD.backgroundColor!
            
            preferences.positioning.maxWidth = 130
            
            preferences.animating.dismissTransform = CGAffineTransform(translationX: 100, y: 0)
            preferences.animating.showInitialTransform = CGAffineTransform(translationX: 100, y: 0)
            preferences.animating.showInitialAlpha = 0
            preferences.animating.showDuration = 1
            preferences.animating.dismissDuration = 1
            
            EasyTipView.show(forView: self.buttonD,
                text: "Tip view within the topmost window. Tap to dismiss.",
                preferences: preferences)
        }
    }
    
    func configureUI () {
        let color = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        
        buttonA.backgroundColor = UIColor(hue:0.58, saturation:0.1, brightness:1, alpha:1)
        
        self.navigationController?.view.tintColor = color
        
        self.buttonB.backgroundColor = color
        self.smallContainerView.backgroundColor = color
    }
}

