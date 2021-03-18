//
//  NestedScrollViewExtension.swift
//  NestedScrollView
//
//  Created by Yanni Wang on 17/3/21.
//

import UIKit
import EasySwiftHook

// TODO: rename project and github
public extension UIScrollView {
    
    private static var embeddedScrollViewKey = 0
    @objc var embeddedScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.embeddedScrollViewKey) as? UIScrollView
        }
        
        set {
            newValue?.isUserInteractionEnabled = false
            objc_setAssociatedObject(self, &UIScrollView.embeddedScrollViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            try! setupHookIfNeed()
        }
    }
    
    private func setupHookIfNeed() throws {
        guard self.keyValueObservation == nil else {
            return
        }
        
        self.keyValueObservation = self.observe(\.panGestureRecognizer.state) { (view, _) in
            switch view.panGestureRecognizer.state {
            case .began:
                view.embeddedScrollViewContentOffsetYWhenTouchBegin = view.embeddedScrollView?.contentOffset.y ?? 0
            default: break
                
            }
        }
        
        _ = try hookInstead(object: self, selector: #selector(setter: UIScrollView.contentOffset), closure: { original, view, sel, point in
            let newY = view.getNewY(oldY: point.y)
            original(view, sel, CGPoint.init(x: point.x, y: newY))
        } as @convention(block) ((UIScrollView, Selector, CGPoint) -> Void, UIScrollView, Selector, CGPoint) -> Void)
    }
    
    private func getNewY(oldY: CGFloat) -> CGFloat {
        guard let embeddedScrollView = self.embeddedScrollView,
              let embeddedSuperView = embeddedScrollView.superview else {
            return oldY
        }
        let embeddedFrameY = embeddedSuperView.convert(embeddedScrollView.frame.origin, to: self).y
        switch self.state {
        case .ahead:
            if oldY <= embeddedFrameY {
                return oldY + self.embeddedScrollViewContentOffsetYWhenTouchBegin
            } else {
                embeddedScrollView.contentOffset.y = oldY - embeddedFrameY
                self.state = .embedded
                return embeddedFrameY
            }
        case .embedded:
            let newY = oldY - embeddedFrameY + self.embeddedScrollViewContentOffsetYWhenTouchBegin
            if newY < 0 {
                embeddedScrollView.contentOffset.y = 0
                self.state = .ahead
                return embeddedFrameY + newY
            } else if newY > embeddedScrollView.contentSize.height - embeddedScrollView.frame.height {
                embeddedScrollView.contentOffset.y = embeddedScrollView.contentSize.height - embeddedScrollView.frame.height
                self.state = .tail
                return embeddedFrameY + (newY - (embeddedScrollView.contentSize.height - embeddedScrollView.frame.height))
            } else {
                embeddedScrollView.contentOffset.y = newY
                return embeddedFrameY
            }
        case .tail:
            if oldY >= embeddedFrameY {
                return oldY + self.embeddedScrollViewContentOffsetYWhenTouchBegin - embeddedScrollView.frame.height
            } else {
                embeddedScrollView.contentOffset.y = (embeddedScrollView.contentSize.height - embeddedScrollView.frame.height) - (oldY - embeddedFrameY)
                self.state = .embedded
                return embeddedFrameY
            }
        }
    }
    
    // MARK: Getter setter
    
    private static var embeddedScrollViewContentOffsetYWhenTouchBeginKey = 0
    private var embeddedScrollViewContentOffsetYWhenTouchBegin: CGFloat {
        get {
            guard let number = objc_getAssociatedObject(self, &UIScrollView.embeddedScrollViewContentOffsetYWhenTouchBeginKey) as? NSNumber else {
                return 0
            }
            return CGFloat.init(number.floatValue)
        }
        
        set {
            objc_setAssociatedObject(self, &UIScrollView.embeddedScrollViewContentOffsetYWhenTouchBeginKey, NSNumber.init(value: Float.init(newValue)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static var keyValueObservationKey = 0
    var keyValueObservation: NSKeyValueObservation? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.keyValueObservationKey) as? NSKeyValueObservation
        }
        
        set {
            objc_setAssociatedObject(self, &UIScrollView.keyValueObservationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // TODO: 这个可以去掉
    enum State: Int {
        case ahead
        case embedded
        case tail
    }
    
    private static var stateKey = 0
    private var state: State {
        get {
            guard let number = objc_getAssociatedObject(self, &UIScrollView.stateKey) as? NSNumber else {
                return .ahead
            }
            return State.init(rawValue: number.intValue) ?? .ahead
        }
        
        set {
            objc_setAssociatedObject(self, &UIScrollView.stateKey, NSNumber.init(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
