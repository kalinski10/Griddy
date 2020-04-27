//
//  BottomCollectionView.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/01/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

class BottomCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDropDelegate {
    
    public var bottomCollection = [UIImage]()
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        delegate = self
        dataSource = self
        dropDelegate = self

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottomCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: "bottomCollectioViewCell", for: indexPath) as! CollectionViewCell
        cell.bottomImageView.image = bottomCollection[indexPath.row]
        cell.layer.borderWidth = CGFloat(2)
        cell.layer.borderColor = CGColor(srgbRed: 212/255, green: 175/255, blue: 55/255, alpha: 1)

        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destIndexPath:IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections
            let items = collectionView.numberOfItems(inSection: section)
            destIndexPath = IndexPath(item: items, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            guard let imageArray = items as? [UIImage] else {return}
            
            self.bottomCollection.remove(at: destIndexPath.row)
            self.bottomCollection.insert(imageArray.first!, at: destIndexPath.row)
            collectionView.insertItems(at: [destIndexPath])
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
