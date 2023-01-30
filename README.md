# EmbeddedScrollView

Add a vertical UIScrollView into another vertical UIScrollView on iOS. It makes users feel like it's a single UIScrollView. This tool resolve the gesture conflict between thw two UIScrollViews.

How it works: Hook the `scrollViewDidScroll` method of a UIScrollView by [SwiftHook](https://github.com/623637646/SwiftHook), calculate and reset the `offset` of the UIScrollView.

It supports Swift and Objective-C

![ezgif com-gif-maker](https://user-images.githubusercontent.com/5275802/111632055-0f82c180-882f-11eb-87de-a8480dab060a.gif)

# How to use EmbeddedScrollView

Just one line code to do it!

```swift
outerScrollView.embeddedScrollView = embeddedScrollView
```

The API is in an extension.
```swift
extension UIScrollView {

    @objc public var embeddedScrollView: UIScrollView?
}
```


# How to integrate EmbeddedScrollView?

**EmbeddedScrollView** can be integrated by [cocoapods](https://cocoapods.org/). 

```
pod 'EmbeddedScrollView'
```

Or use Swift Package Manager. SPM is supported from **1.1.0**.

# Requirements

- iOS 10.0+
- Xcode 11+
- Swift 5.0+
