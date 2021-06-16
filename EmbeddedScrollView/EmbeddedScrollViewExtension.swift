//
//  EmbeddedScrollViewExtension.swift
//  EmbeddedScrollView
//
//  Created by Yanni Wang on 17/3/21.
//

import UIKit
#if SWIFT_PACKAGE
import SwiftHook
#else
import EasySwiftHook
#endif

private class EmbeddedScrollViewDelegate: NSObject, UIScrollViewDelegate {
    
    weak var originalDelegate: UIScrollViewDelegate?
        
    override func responds(to aSelector: Selector!) -> Bool {
        guard !super.responds(to: aSelector) else {
            return true
        }
        guard let originalDelegate = self.originalDelegate else {
            return false
        }
        return originalDelegate.responds(to: aSelector)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.didScroll()
        if let originalDelegate = self.originalDelegate {
            originalDelegate.scrollViewDidScroll?(scrollView)
        }
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let target = super.forwardingTarget(for: aSelector) {
            return target
        }
        return self.originalDelegate
    }
}

public extension UIScrollView {
    
    private static var embeddedScrollViewKey = 0
    @objc var embeddedScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.embeddedScrollViewKey) as? UIScrollView
        }
        
        set {
            newValue?.isScrollEnabled = false
            objc_setAssociatedObject(self, &UIScrollView.embeddedScrollViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.setupIfNeed()
        }
    }
    
    private static var embeddedDelegateKey = 0
    private var embeddedDelegate: EmbeddedScrollViewDelegate? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.embeddedDelegateKey) as? EmbeddedScrollViewDelegate
        }
        
        set {
            objc_setAssociatedObject(self, &UIScrollView.embeddedDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func setupIfNeed() {
        guard self.embeddedDelegate == nil else {
            return
        }
        let newDelegate = EmbeddedScrollViewDelegate.init()
        newDelegate.originalDelegate = self.delegate
        self.embeddedDelegate = newDelegate
        self.delegate = newDelegate
        try! hookInstead(object: self, selector: #selector(setter: UIScrollView.delegate), closure: { _, view, _, delegate in
            view.embeddedDelegate?.originalDelegate = delegate
        } as @convention(block) ((UIScrollView, Selector, UIScrollViewDelegate?) -> Void, UIScrollView, Selector, UIScrollViewDelegate?) -> Void)
        try! hookInstead(object: self, selector: #selector(getter: UIScrollView.delegate), closure: { _, view, _ in
            return view.embeddedDelegate?.originalDelegate
        } as @convention(block) ((UIScrollView, Selector) -> UIScrollViewDelegate?, UIScrollView, Selector) -> UIScrollViewDelegate?)
    }
    
    fileprivate func didScroll() {
        guard let embeddedScrollView = self.embeddedScrollView,
              let embeddedSuperView = embeddedScrollView.superview,
              embeddedScrollView.window != nil else {
            return
        }
        guard self.frame.height.isLessThanOrEqualTo(embeddedScrollView.frame.height) else {
            print("The height of the embedded ScrollView must be equal or greater than the height of the outer ScrollView")
            return
        }
        let embeddedFrameY = embeddedSuperView.convert(embeddedScrollView.frame.origin, to: self).y
        let diff = self.contentOffset.y - embeddedFrameY
        let maxEmbeddedScrollViewOffsetY = embeddedScrollView.contentSize.height - embeddedScrollView.frame.height
        let currentEmbeddedScrollViewOffsetY = embeddedScrollView.contentOffset.y
        if currentEmbeddedScrollViewOffsetY.isZero {
            // ahead
            if self.contentOffset.y > embeddedFrameY {
                embeddedScrollView.contentOffset.y += diff
                self.contentOffset.y = embeddedFrameY
            }
        } else if currentEmbeddedScrollViewOffsetY.isEqual(to: maxEmbeddedScrollViewOffsetY) {
            // tail
            if self.contentOffset.y < embeddedFrameY {
                embeddedScrollView.contentOffset.y += diff
                self.contentOffset.y = embeddedFrameY
            }
        } else {
            // embedded
            let newEmbeddedOffsetY = embeddedScrollView.contentOffset.y + diff
            if newEmbeddedOffsetY < 0 {
                embeddedScrollView.contentOffset.y = 0
                self.contentOffset.y = embeddedFrameY + diff
            } else if newEmbeddedOffsetY > maxEmbeddedScrollViewOffsetY {
                embeddedScrollView.contentOffset.y = maxEmbeddedScrollViewOffsetY
                self.contentOffset.y = embeddedFrameY + diff
            } else {
                embeddedScrollView.contentOffset.y = newEmbeddedOffsetY
                self.contentOffset.y = embeddedFrameY
            }
        }
    }
}
