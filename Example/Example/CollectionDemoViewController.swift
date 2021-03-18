//
//  CollectionDemoViewController.swift
//  Example
//
//  Created by Yanni Wang on 18/3/21.
//

import UIKit

class EmbeddedCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource {
    
    var embeddedCollectionView: UICollectionView! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let collectionViewLayout = UICollectionViewFlowLayout.init()
        collectionViewLayout.itemSize = CGSize.init(width: self.frame.width, height: 44)
        let embeddedCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: collectionViewLayout)
        embeddedCollectionView.backgroundColor = .red
        embeddedCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        embeddedCollectionView.dataSource = self
        self.contentView.addSubview(embeddedCollectionView)
        self.embeddedCollectionView = embeddedCollectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = String.init(indexPath.row)
        } else {
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
            label.tag = 1
            label.text = String.init(indexPath.row)
            cell.contentView.addSubview(label)
            let split = UIView.init(frame: CGRect.init(x: 0, y: 0, width: collectionView.frame.width, height: 0.5))
            split.backgroundColor = .black
            cell.contentView.addSubview(split)
        }
        return cell
    }
}

class CollectionDemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let embeddedCollectionViewIndex = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = self.view.frame.height - self.navigationController!.navigationBar.frame.maxY
        let width = self.view.frame.width
        
        // outer
        let collectionViewLayout = UICollectionViewFlowLayout.init()
        let outerCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), collectionViewLayout: collectionViewLayout)
        outerCollectionView.backgroundColor = .white
        outerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        outerCollectionView.register(EmbeddedCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(EmbeddedCollectionViewCell.self))
        outerCollectionView.dataSource = self
        outerCollectionView.delegate = self
        self.view.addSubview(outerCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == embeddedCollectionViewIndex {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(EmbeddedCollectionViewCell.self), for: indexPath)
            collectionView.embeddedScrollView = (cell as! EmbeddedCollectionViewCell).embeddedCollectionView
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = String.init(indexPath.row)
            } else {
                let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
                label.tag = 1
                label.text = String.init(indexPath.row)
                cell.contentView.addSubview(label)
                let split = UIView.init(frame: CGRect.init(x: 0, y: 0, width: collectionView.frame.width, height: 0.5))
                split.backgroundColor = .black
                cell.contentView.addSubview(split)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: indexPath.row == embeddedCollectionViewIndex ? collectionView.frame.height :  44)
    }
    

}
