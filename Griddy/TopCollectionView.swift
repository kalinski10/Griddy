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
        cell.layer.borderWidth = CGFloat(2)
        cell.layer.borderColor = CGColor(srgbRed: 212, green: 175, blue: 0, alpha: 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.topCollection[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragItem
        
        return [dragItem]
        
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
            
            self.topCollection.remove(at: destIndexPath.row)
            self.topCollection.insert(imageArray.first!, at: destIndexPath.row)
            collectionView.insertItems(at: [destIndexPath])
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destIndexPath, collectionView: collectionView)
            print("reordered")
        }
        
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {

            collectionView.performBatchUpdates({
                self.topCollection.remove(at: sourceIndexPath.item)
                self.topCollection.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.item)

                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
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
