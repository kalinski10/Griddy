//
//  TopCollectionView.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/01/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

class TopCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    public var topCollection = [UIImage]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dataSource = self
        delegate = self
        dragDelegate = self
        dragInteractionEnabled = true
        dropDelegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "topCollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.topImageView.image = topCollection[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.topCollection[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragItem
        
        return [dragItem]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard (coordinator.destinationIndexPath) != nil else {return}
        guard coordinator.items.first != nil else {return}
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
