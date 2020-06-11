//
//  TopCollectionView.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/01/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

class TopCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public var shuffledImages = [UIImage]()
    private static let kID = "topCollectionViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        dataSource = self
        delegate = self
        dragDelegate = self
        dropDelegate = self
        dragInteractionEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // + 2 for the additional cells
        return shuffledImages.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let width = collectionView.bounds.width / 6 - 5
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        if indexPath.row < shuffledImages.count {
            guard let cell = dequeueReusableCell(withReuseIdentifier: TopCollectionView.kID, for: indexPath) as? CollectionViewCell else { return CollectionViewCell() } // also cghnage the bottom colletion view
            cell.topImageView.image = shuffledImages[indexPath.row]
            cell.layer.borderWidth = CGFloat(2)
            cell.layer.borderColor = .gridyGold
            return cell
        } else if indexPath.row == shuffledImages.count {
            
            let emptyCell = dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath)
            return emptyCell
        } else {
            
            let eyeCell = dequeueReusableCell(withReuseIdentifier: "eyeCell", for: indexPath)
            // adding the eye image into the cell
            let image = UIImageView(image: UIImage(named: "eye"))
            eyeCell.addSubview(image)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.topAnchor.constraint(equalTo: eyeCell.topAnchor).isActive = true
            image.bottomAnchor.constraint(equalTo: eyeCell.bottomAnchor).isActive = true
            image.leadingAnchor.constraint(equalTo: eyeCell.leadingAnchor).isActive = true
            image.trailingAnchor.constraint(equalTo: eyeCell.trailingAnchor).isActive = true
            image.contentMode = .scaleAspectFit
            let eyeButton = UIButton()
            eyeCell.addSubview(eyeButton)
            eyeButton.translatesAutoresizingMaskIntoConstraints = false
            eyeButton.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
            eyeButton.bottomAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
            eyeButton.leadingAnchor.constraint(equalTo: image.leadingAnchor).isActive = true
            eyeButton.trailingAnchor.constraint(equalTo: image.trailingAnchor).isActive = true
            eyeButton.addTarget(self, action: #selector(eyeTapped), for: .touchUpInside)
            eyeButton.backgroundColor = .red // temporary just for troubleshooting
            return eyeCell
        }
    }
    
    @objc public func eyeTapped() { // need to mve them all into the the gameVc in order to get it working
        print("eye Button Tapper")
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == shuffledImages.count + 1 { // does nothing
            print("hidden image view")
        }
        print("you have selcted the item at index \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
//        let section = collectionView.numberOfSections
//        let items = collectionView.numberOfItems(inSection: section)
//        let indexPath = IndexPath(item: items, section: section)
//        if indexPath.row > shuffledImages.count {
//            return false
//        }
//        else {
//            return true
//        }
        return true // unnessecary unless i wanna disable a drop on certain cells // like an empty cell
    }
   
}

extension TopCollectionView: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row < shuffledImages.count {
            let item = shuffledImages[indexPath.row]
            let itemProvider = NSItemProvider(object: item as UIImage)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = dragItem
            return [dragItem]
        }
        return[]
    }
 
}

extension TopCollectionView: UICollectionViewDropDelegate {
    
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
            
            self.shuffledImages.remove(at: destIndexPath.row)
            self.shuffledImages.insert(imageArray.first!, at: destIndexPath.row)
            collectionView.insertItems(at: [destIndexPath])
            collectionView.deleteItems(at: [destIndexPath]) // revisit
        }
        
        if coordinator.proposal.operation == .move { // not sure why it doesnt trigger // not sure if i need this
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destIndexPath, collectionView: collectionView)
            print("reordered")
            collectionView.reloadData()
        }
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates({
                self.shuffledImages.remove(at: sourceIndexPath.item)
                self.shuffledImages.insert(item.dragItem.localObject as! UIImage, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
    }
    
}
