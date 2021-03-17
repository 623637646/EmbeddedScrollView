//
//  ViewController.swift
//  Example
//
//  Created by Yanni Wang on 17/3/21.
//

import UIKit
import NestedScrollView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // outer
        let outerContent = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 3))
        let outerGradientLayer = CAGradientLayer()
        outerGradientLayer.colors = [UIColor.orange.cgColor, UIColor.blue.cgColor]
        outerGradientLayer.locations = [0, 1]
        outerGradientLayer.frame = outerContent.bounds
        outerContent.layer.addSublayer(outerGradientLayer)
        
        let outerScrollView = UIScrollView.init(frame: self.view.bounds)
        outerScrollView.addSubview(outerContent)
        outerScrollView.contentSize = outerContent.frame.size
        self.view.addSubview(outerScrollView)
        
        // inside
        let insideContent = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 2))
        let insideGradientLayer = CAGradientLayer()
        insideGradientLayer.colors = [UIColor.yellow.cgColor, UIColor.red.cgColor]
        insideGradientLayer.locations = [0, 1]
        insideGradientLayer.frame = insideContent.bounds
        insideContent.layer.addSublayer(insideGradientLayer)
        
        let insideScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height))
        insideScrollView.addSubview(insideContent)
        insideScrollView.contentSize = insideContent.frame.size
        outerContent.addSubview(insideScrollView)
        
        // setup Internal ScrollView
        outerScrollView.setupInternalScrollView(insideScrollView)
    }


}

