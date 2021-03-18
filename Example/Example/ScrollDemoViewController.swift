//
//  ViewController.swift
//  Example
//
//  Created by Yanni Wang on 17/3/21.
//

import UIKit
import NestedScrollView

class MyScrollView: UIScrollView {
    deinit {
        print("deinit called")
    }
}

// TODO: uitable uicollectionview demo
class ScrollDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // outer
        let navigationBar = self.navigationController!.navigationBar
        let outerScrollView = MyScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - navigationBar.frame.maxY))
        
        let outerContent = self.createContentView(frame: CGRect.init(x: 0, y: 0, width: outerScrollView.frame.width, height: outerScrollView.frame.height * 3), topColor: .orange, bottomColor: .blue)

        outerScrollView.addSubview(outerContent)
        outerScrollView.contentSize = outerContent.frame.size
        self.view.addSubview(outerScrollView)
        
        // inside
        let insideScrollView = MyScrollView.init(frame: CGRect.init(x: 0, y: outerScrollView.frame.height, width: outerScrollView.frame.width, height: outerScrollView.frame.height))
        
        let insideContent = self.createContentView(frame: CGRect.init(x: 0, y: 0, width: insideScrollView.frame.width, height: insideScrollView.frame.height * 2), topColor: .yellow, bottomColor: .red)
        
        insideScrollView.addSubview(insideContent)
        insideScrollView.contentSize = insideContent.frame.size
        outerContent.addSubview(insideScrollView)
        
        // setup Internal ScrollView
        outerScrollView.embeddedScrollView = insideScrollView
    }
    
    func createContentView(frame: CGRect, topColor: UIColor, bottomColor: UIColor) -> UIView {
        let contentView = UIView.init(frame: frame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = contentView.frame
        contentView.layer.addSublayer(gradientLayer)
        
        let hight = 40
        for index in 0 ... Int(contentView.frame.height) / hight {
            let split = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(index * hight), width: contentView.frame.width, height: 1))
            split.backgroundColor = .black
            contentView.addSubview(split)
        }
        return contentView
    }

}

