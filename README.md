<img src="https://raw.githubusercontent.com/teodorpatras/EasyTipView/master/assets/easytipview.png" alt="EasyTipView: fully customisable tooltip view written in Swift" style="width: 500px;"/>

![Swift3](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat")
[![Platform](https://img.shields.io/cocoapods/p/EasyTipView.svg?style=flat)](http://cocoapods.org/pods/EasyTipView)
[![Build Status](https://travis-ci.org/teodorpatras/EasyTipView.svg)](https://travis-ci.org/teodorpatras/EasyTipView)
[![Version](https://img.shields.io/cocoapods/v/EasyTipView.svg?style=flat)](http://cocoapods.org/pods/EasyTipView)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/EasyTipView.svg?style=flat)](http://cocoapods.org/pods/EasyTipView)

Description
--------------

```EasyTipView``` is a fully customisable tooltip view written in Swift that can be used as a call to action or informative tip.

|<img src="https://raw.githubusercontent.com/teodorpatras/EasyTipView/master/assets/easytipview.gif" width="320">|<img src="https://raw.githubusercontent.com/teodorpatras/EasyTipView/master/assets/static.png" width="320">|
|----------|-------------|------|

# Contents
1. [Features](#features)
3. [Installation](#installation)
4. [Supported OS & SDK versions](#supported-versions)
5. [Usage](#usage)
6. [Customising the appearance](#customising)
7. [Customising the presentation and dismissal animations](#customising-animations)
8. [Implementing custom transitions](#custom-transitions)
9. [Public interface](#public-interface)
10. [License](#license)
11. [Contact](#contact)

##<a name="features"> Features </a>

- [x] Can be shown pointing to any ``UIBarItem`` or ``UIView`` subclass.
- [x] support for any arrow direction `←, →, ↑, ↓`
- [x] Automatic orientation change adjustments.
- [x] Fully customisable appearance.
- [x] Fully customisable presentation and dismissal animations.


<a name="installation"> Installation </a>
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

pod 'EasyTipView', '~> 1.0.2'
```

Then, run the following command:

```bash
$ pod install
```

In case Xcode complains (<i>"Cannot load underlying module for EasyTipView"</i>) go to Product and choose Clean (or simply press <kbd>⇧</kbd><kbd>⌘</kbd><kbd>K</kbd>).


### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Alamofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "teodorpatras/EasyTipView"
```

Run `carthage update` to build the framework and drag the built `EasyTipView.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate EasyTipView into your project manually.

<a name="supported-versions"> Supported OS & SDK Versions </a>
-----------------------------

* Supported build target - iOS 8.0 (Xcode 7.x)

<a name="usage"> Usage </a>
--------------

1) First you should customize the preferences:
```swift

var preferences = EasyTipView.Preferences()
preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
preferences.drawing.foregroundColor = UIColor.whiteColor()
preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top

/*
 * Optionally you can make these preferences global for all future EasyTipViews
 */
EasyTipView.globalPreferences = preferences

```

2) Secondly call the ``show(animated: forView: withinSuperview: text: preferences: delegate:)`` method:
```swift
EasyTipView.show(forView: self.buttonB,
withinSuperview: self.navigationController?.view,
text: "Tip view inside the navigation controller's view. Tap to dismiss!",
preferences: preferences,
delegate: self)
```

**Note that if you set the** ```EasyTipView.globalPreferences```**, you can ommit the** ```preferences``` **parameter in all calls. Additionally, you can also ommit the** ``withinSuperview`` **parameter and the** ``EasyTipView`` **will be shown within the main application window**.

*Alternatively, if you want to dismiss the ``EasyTipView`` programmatically later on, you can use one of the instance methods:*

```swift

let tipView = EasyTipView(text: "Some text", preferences: preferences)
tipView.show(forView: someView, withinSuperview: someSuperview)

// later on you can dismiss it
tipView.dismiss()
```
<a name="customising"> Customising the appearance </a>
--------------
In order to customise the `EasyTipView` appearance and behaviour, you can play with the `Preferences` structure which encapsulates all the customizable properties of the ``EasyTipView``. These preferences have been split into three structures:
* ```Drawing``` - encapsulates customisable properties specifying how ```EastTipView``` will be drawn on screen.
* ```Positioning``` - encapsulates customisable properties specifying where ```EasyTipView``` will be drawn within its own bounds.
* ```Animating``` - encapsulates customisable properties specifying how ```EasyTipView``` will animate on and off screen.

| `Drawing ` attribute   |      Description      |
|----------|-------------|------|
|`cornerRadius`| The corner radius of the tip view bubble.|
|`arrowHeight`| The height of the arrow positioned at the top or bottom of the bubble.|
|`arrowWidth`| The width of the above mentioned arrow.|
|`foregroundColor`| The text color.|
|`backgroundColor`| The background color of the bubble.|
|`arrowPosition`| The position of the arrow. This can be: <br /> **+** `.top`: on top of the bubble <br /> **+** `.bottom`: at the bottom of the bubble.<br /> **+** `.left`: on the left of the bubble <br /> **+** `.right`: on the right of the bubble <br /> **+** `.any`: use this option to let the `EasyTipView` automatically find the best arrow position. <br />**If the passed in arrow cannot be applied due to layout restrictions, a different arrow position will be automatically assigned.**|
|`textAlignment`| The alignment of the text.|
|`borderWidth`| Width of the optional border to be applied on the bubble.|
|`borderColor`| Color of the optional border to be applied on the bubble. **In order for the border to be applied, `borderColor` needs to be different that `UIColor.clear` and `borderWidth` > 0**|
|`font`| Font to be applied on the text. |

| `Positioning ` attribute   |      Description      |
|----------|-------------|------|
|`bubbleHInset`| Horizontal bubble inset witin its container.|
|`bubbleVInset`| Vertical bubble inset within its container.|
|`textHInset`| Text horizontal inset within the bubble.|
|`textVInset`| Text vertical inset within the bubble.|
|`maxWidth`| Max bubble width.|

| `Animating ` attribute   |      Description      |
|----------|-------------|------|
|`dismissTransform`| `CGAffineTransform` specifying how the bubble will be dismissed. |
|`showInitialTransform`| `CGAffineTransform` specifying the initial transform to be applied on the bubble before it is animated on screen. |
|`showFinalTransform`| `CGAffineTransform` specifying how the bubble will be animated on screen. |
|`springDamping`| Spring animation damping.|
|`springVelocity`| Spring animation velocity.|
|`showInitialAlpha`|Initial alpha to be applied on the tip view before it is animated on screen.|
|`dismissFinalAlpha`|The alpha to be applied on the tip view when it is animating off screen.|
|`showDuration`|Show animation duration.|
|`dismissDuration`|Dismiss animation duration.|

<a name="customising-animations"> Customising the presentation or dismissal animations </a>
--------------

The default animations for showing or dismissing are scale up and down. If you want to change the default behaviour, you need to change the attributes of the ``animating`` property within the preferences. An example could be:

```swift
preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: -15)
preferences.animating.showInitialAlpha = 0
preferences.animating.showDuration = 1.5
preferences.animating.dismissDuration = 1.5
```

This produces the following animations:
<br><br><img src="https://raw.githubusercontent.com/teodorpatras/EasyTipView/master/assets/animation.gif" width="200">

For more animations, checkout the example project.
*Once you configured the animations, a good idea would be to __make these preferences global__, for all future instances of `EasyTipView` by assigning it to ```EasyTipView.globalPreferences```.*


<a name="public-interface"> Public interface </a>
--------------

###Delegate
`EasyTipViewDelegate` is a custom protocol which defines one method to be called on the delegate after the ``EasyTipView`` has been dismissed.

```swift

public protocol EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView : EasyTipView)
}
```

###Public methods

```swift
/**
 Presents an EasyTipView pointing to a particular UIBarItem instance within the specified superview

 - parameter animated:    Pass true to animate the presentation.
 - parameter item:        The UIBarButtonItem or UITabBarItem instance which the EasyTipView will be pointing to.
 - parameter superview:   A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
 - parameter text:        The text to be displayed.
 - parameter preferences: The preferences which will configure the EasyTipView.
 - parameter delegate:    The delegate.
*/
public class func show(animated: Bool = true, forItem item: UIBarItem, withinSuperview superview: UIView? = nil, text: String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil)
    
 /**
 Presents an EasyTipView pointing to a particular UIView instance within the specified superview
     
 - parameter animated:    Pass true to animate the presentation.
 - parameter view:        The UIView instance which the EasyTipView will be pointing to.
 - parameter superview:   A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
 - parameter text:        The text to be displayed.
 - parameter preferences: The preferences which will configure the EasyTipView.
 - parameter delegate:    The delegate.
*/
public class func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil, text:  String, preferences: Preferences = EasyTipView.globalPreferences, delegate: EasyTipViewDelegate? = nil)
    
/**
 Presents an EasyTipView pointing to a particular UIBarItem instance within the specified superview
     
 - parameter animated:  Pass true to animate the presentation.
 - parameter item:      The UIBarButtonItem or UITabBarItem instance which the EasyTipView will be pointing to.
 - parameter superview: A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
*/
public func show(animated: Bool = true, forItem item: UIBarItem, withinSuperView superview: UIView? = nil)
    
/**
 Presents an EasyTipView pointing to a particular UIView instance within the specified superview
     
 - parameter animated:  Pass true to animate the presentation.
 - parameter view:      The UIView instance which the EasyTipView will be pointing to.
 - parameter superview: A view which is part of the UIView instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
*/
public func show(animated: Bool = true, forView view: UIView, withinSuperview superview: UIView? = nil)

/**
 Dismisses the EasyTipView
     
 - parameter completion: Completion block to be executed after the EasyTipView is dismissed.
*/
public func dismiss(withCompletion completion: (() -> ())? = nil)
```

<a name="license"> License </a>
--------------

```EasyTipView``` is developed by [Teodor Patraş](https://www.teodorpatras.com) and is released under the MIT license. See the ```LICENSE``` file for details.

Logo was created using Bud Icons Launch graphic by [Budi Tanrim](http://buditanrim.co) from [FlatIcon](http://www.flaticon.com/) which is licensed under [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/). Made with [Logo Maker](http://logomakr.com).

<a name="contact"> Contact </a>
--------------

You can follow or drop me a line on [my Twitter account](https://twitter.com/teodorpatras). If you find any issues on the project, you can open a ticket. Pull requests are also welcome.
