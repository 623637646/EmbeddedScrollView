# EmbeddedScrollView

Add a vertical UIScrollView into another vertical UIScrollView for iOS. It supports Swift and Objective-C

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

Feel free to send Pull Request to support [Carthage](https://github.com/Carthage/Carthage) or [Swift Packages](https://developer.apple.com/documentation/swift_packages).

# Requirements

- iOS 10.0+
- Xcode 11+
- Swift 5.0+
