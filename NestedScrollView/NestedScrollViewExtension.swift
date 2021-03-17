//
//  NestedScrollViewExtension.swift
//  NestedScrollView
//
//  Created by Yanni Wang on 17/3/21.
//

import UIKit

public extension UIScrollView {
    @objc func setupInternalScrollView(_ internalScrollView: UIScrollView) {
        internalScrollView.bounces = false
    }
}
