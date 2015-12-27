# EasyTipView

[![Version](https://img.shields.io/cocoapods/v/EasyTipView.svg?style=flat)](http://cocoapods.org/pods/EasyTipView)
[![License](https://img.shields.io/cocoapods/l/EasyTipView.svg?style=flat)](http://cocoapods.org/pods/EasyTipView)
[![Platform](https://img.shields.io/cocoapods/p/EasyTipView.svg?style=flat)](http://cocoapods.org/pods/EasyTipView)

Purpose
--------------

EasyTipView is a custom tooltip view written in Swift that can be used as a call to action or informative tip. It can be presented for 
any ``UIBarButtonItem`` or ``UIView`` subclass. In addition it handles automatically orientation changes and will always point to the correct view or item.

![Example](/../master/images/preview.gif)

Installation
--------------

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate EasyTipView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'EasyTipView', '~> 0.1.3'
```

Then, run the following command:

```bash
$ pod install
```

In case Xcode complains (<i>"Cannot load underlying module for EasyTipView"</i>) go to Product and choose Clean (or simply press <kbd>⇧</kbd><kbd>⌘</kbd><kbd>K</kbd>).

Usage
--------------

1) First you should customize the preferences:
```swift
  
  var preferences = EasyTipView.Preferences()
  preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
  preferences.drawing.foregroundColor = UIColor.whiteColor()
  preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
  preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
  
  /*
   * Optionally you can make these preferences global for all EasyTipViews
   */
  EasyTipView.globalPreferences = preferences
  
```

2) Secondly you call the ``showAnimated:forView:withinSuperview:text:preferences:delegate:`` method:
```swift
  EasyTipView.showAnimated(true, 
  forView: self.buttonB, 
  withinSuperview: self.navigationController?.view,
  text: "Tip view inside the navigation controller's view. Tap to dismiss!",
  preferences: preferences,
  delegate: self)
```

**Note that if you set the ```EasyTipView.globalPreferences```, you can ommit the ```preferences``` parameter.**

Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 8.0 (Xcode 6.x)

Custom types
--------------

```swift 

public protocol EasyTipViewDelegate : class {
    func easyTipViewDidDismiss(tipView : EasyTipView)
}

```

Custom protocol which defines one method to be called on the delegate after the ``EasyTipView`` has been dismissed.

```swift
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
        
      public var drawing      = Drawing()
      public var positioning  = Positioning()
  }
```
Custom structure which encapsulates all the customizable properties of the ``EasyTipView``. These preferences have been split into two structures:
* ```Drawing``` - encapsulates customizable properties specifying how ```EastTipView``` will be drawn on screen.
* ```Positioning``` - encapsulates customizable properties specifying where ```EasyTipView``` will be drawn within its own bounds.

```swift
enum ArrowPosition {
  case Top
  case Bottom
}
```
Custom enumeration which defines the supported arrow positions.

Methods
--------------

```swift
class func showAnimated(animated : Bool = true, forView view : UIView, withinSuperview superview : UIView? = nil, text :  NSString, preferences: Preferences = EasyTipView.globalPreferences, delegate : EasyTipViewDelegate? = nil)
```

Call this class method when you want to display ``EasyTipView`` pointing to a ``UIView`` subclass. **If you do not specify a superview, ``EasyTipView`` will be displayed within the main window.**

```swift
func showForView(view : UIView, withinSuperview sview : UIView? = nil, animated : Bool = true)
```

The same as the above method, only difference being that this is an instance method.

```swift
class func showAnimated(animated : Bool = true, forItem item : UIBarButtonItem, withinSuperview superview : UIView? = nil, text : NSString, preferences: Preferences = EasyTipView.globalPreferences, delegate : EasyTipViewDelegate? = nil)
```

Call this class method when you want to display ``EasyTipView`` pointing to a ``UIBarButtonItem`` subclass. **If you do not specify a superview, ``EasyTipView`` will be displayed within the main window.**


```swift
func showForItem(item : UIBarButtonItem, withinSuperView sview : UIView? = nil, animated : Bool = true)
```

The same as the above method, only difference being that this is an instance method.

```swift
func dismissWithCompletion(completion : ((finished : Bool) -> Void)?)
```

Use this method to programmatically hide an ``EasyTipView``.
