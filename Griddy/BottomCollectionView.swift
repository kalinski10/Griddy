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
        dropDelegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard (coordinator.destinationIndexPath) != nil else {return}
        guard coordinator.items.first != nil else {return}
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "bottomCollectioViewCell", for: indexPath) as! CollectionViewCell
        return cell
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
