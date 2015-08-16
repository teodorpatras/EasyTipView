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

pod 'EasyTipView', '~> 0.1.0'
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
  preferences.bubbleColor = UIColor(hue:0.58, saturation:0.1, brightness:1, alpha:1)
  preferences.textColor = UIColor.darkGrayColor()
  preferences.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
  preferences.textAlignment = NSTextAlignment.Center
  
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

Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 7.0 (Xcode 6.x)

Custom types
--------------

```swift 

@objc protocol EasyTipViewDelegate {
    func easyTipViewDidDismiss(tipView : EasyTipView)
}

```

Custom protocol which defines one method to be called on the delegate after the ``EasyTipView`` has been dismissed.
```swift
struct Preferences {
  var systemFontSize          :   CGFloat                =   15
  var textColor               :   UIColor                =   UIColor.whiteColor()
  var bubbleColor             :   UIColor                =   UIColor.redColor()
  var arrowPosition           :   ArrowPosition          =   .Bottom
  var font                    :   UIFont?
  var textAlignment           :   NSTextAlignment        =   NSTextAlignment.Center
}
```
Custom structure which encapsulates all the customizable properties of the ``EasyTipView``. If the font is not specified, the tip view will default to the ``UIFont.systemFontOfSize(preferences.systemFontSize)``.

```swift
enum ArrowPosition {
  case Top
  case Bottom
}
```
Custom enumeration which defines the position that the bubble arrow can take.

Methods
--------------

```swift
class func showAnimated(animated : Bool, forView view : UIView, withinSuperview superview : UIView?, text :  NSString, preferences: Preferences?, delegate : EasyTipViewDelegate?)
```

Call this class method when you want to display the ``EasyTipView`` pointing to a ``UIView`` subclass. **superview parameter is optional. If you do not specify a superview, the ``EasyTipView`` will be displayed within the main window.**

```swift
func showForView(view : UIView, withinSuperview sview : UIView?, animated : Bool)
```

The same as the above method, only difference is that this is an instance method.

```swift
class func showAnimated(animated : Bool, forItem item : UIBarButtonItem, withinSuperview superview : UIView?, text : NSString, preferences: Preferences?, delegate : EasyTipViewDelegate?)
```

Call this class method when you want to display the ``EasyTipView`` pointing to a ``UIBarButtonItem`` subclass. **superview parameter is optional. If you do not specify a superview, the ``EasyTipView`` will be displayed within the main window.**


```swift
func showForItem(item : UIBarButtonItem, withinSuperView sview : UIView?, animated : Bool)
```

The same as the above method, only difference is that this is an instance method.

```swift
func dismissWithCompletion(completion : ((finished : Bool) -> Void)?)
```

Use this method to programmatically hide the ``EasyTipView`` view.
