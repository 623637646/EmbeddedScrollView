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
class ScrollDemoViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = self.view.frame.height - self.navigationController!.navigationBar.frame.maxY
        let width = self.view.frame.width
        
        // outer
        let outerScrollView = MyScrollView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        outerScrollView.delegate = self
        let outerContent = self.createContentView(frame: CGRect.init(x: 0, y: 0, width: width, height: height * 2.5), topColor: .red, bottomColor: .green)
        outerScrollView.addSubview(outerContent)
        outerScrollView.contentSize = outerContent.frame.size
        self.view.addSubview(outerScrollView)
        
        // inside
        let insideScrollView = MyScrollView.init(frame: CGRect.init(x: 0, y: height / 2 + 100, width: width, height: height + 200))
        let insideContent = self.createContentView(frame: CGRect.init(x: 0, y: 0, width: width - 20, height: height * 2), topColor: .blue, bottomColor: .red)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }

}

