//
//  ViewController.swift
//  EasyTipView
//
//  Created by Teodor Patras on 25.03.15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit
import EasyTipView

class ViewController: UIViewController, EasyTipViewDelegate {
    
    @IBOutlet weak var toolbarItem: UIBarButtonItem!
    @IBOutlet weak var smallContainerView: UIView!
    @IBOutlet weak var navBarItem: UIBarButtonItem!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.configureUI()
        
        var preferences = EasyTipView.Preferences()
        
        preferences.font = UIFont(name: "Futura-Medium", size: 13)
        preferences.textColor = UIColor.whiteColor()
        preferences.bubbleColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.arrowPosition = EasyTipView.ArrowPosition.Top
        
        EasyTipView.setGlobalPreferences(preferences)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.toolbarItemAction()
    }
    
    func easyTipViewDidDismiss(tipView: EasyTipView) {
        println("\(tipView) did dismiss!")
    }
    
    @IBAction func barButtonAction(sender: UIBarButtonItem) {
        EasyTipView.showAnimated(true, forItem: self.navBarItem, withinSuperview: self.navigationController?.view, text: "Tip view for bar button item displayed within the navigation controller's view. Tap to dismiss.", preferences: nil, delegate: self)
    }
    
    @IBAction func toolbarItemAction() {
        EasyTipView.showAnimated(true, forItem: self.toolbarItem, withinSuperview: nil, text: "EasyTipView is an easy to use tooltip view. Tap the buttons to see other tooltips.", preferences: nil, delegate: nil)
    }
    
    @IBAction func buttonAction(sender : UIButton) {
        switch sender {
        case buttonA:
            
            var preferences = EasyTipView.Preferences()
            preferences.bubbleColor = UIColor(hue:0.58, saturation:0.1, brightness:1, alpha:1)
            preferences.textColor = UIColor.darkGrayColor()
            preferences.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
            preferences.textAlignment = NSTextAlignment.Center
            
            let view = EasyTipView(text: "Tip view within the green superview. Tap to dismiss.", preferences: preferences, delegate: nil)
            view.showForView(buttonA, withinSuperview: self.smallContainerView, animated: true)
            
        case buttonB:
            
            var preferences = EasyTipView.globalPreferences()
            preferences.textColor = UIColor.whiteColor()
            preferences.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            preferences.textAlignment = NSTextAlignment.Justified
            
            EasyTipView.showAnimated(true,
                forView: self.buttonB,
                withinSuperview: self.navigationController?.view,
                text: "Tip view inside the navigation controller's view. Tap to dismiss!",
                preferences: preferences,
                delegate: nil)
            
        case buttonC:
            
            var preferences = EasyTipView.globalPreferences()
            preferences.bubbleColor = buttonC.backgroundColor!
                
            EasyTipView.showAnimated(true, forView: buttonC, withinSuperview: self.navigationController?.view, text: "This tip view cannot be presented with the arrow on the top position, so position bottom has been chosen instead. Tap to dismiss.", preferences: preferences, delegate: nil)
            
        default:
            
            var preferences = EasyTipView.globalPreferences()
            preferences.arrowPosition = EasyTipView.ArrowPosition.Bottom
            preferences.font = UIFont.systemFontOfSize(14)
            preferences.bubbleColor = buttonD.backgroundColor!
            
            EasyTipView.showAnimated(true, forView: buttonD, withinSuperview: nil, text: "Tip view within the topmost window. Tap to dismiss.", preferences: preferences, delegate: nil)
        }
    }
    
    func configureUI () {
        var color = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        
        buttonA.backgroundColor = UIColor(hue:0.58, saturation:0.1, brightness:1, alpha:1)
        
        self.navigationController?.view.tintColor = color
        
        self.buttonB.backgroundColor = color
        self.smallContainerView.backgroundColor = color
        
    }
}

