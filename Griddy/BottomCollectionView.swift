//
//  BottomCollectionView.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/01/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

protocol UpdateScoreDelegate {
    func updateScore(score: Double)
}

class BottomCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var scoreDelegate: UpdateScoreDelegate!
    public var bottomCollection = [UIImage]()
    public var correctImages = [UIImage]()
    public var zScore: Double = 30.0
    private static let kID = "bottomCollectioViewCell"
    let shareVC = ShareViewController() // will have to revisit that
    
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
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: BottomCollectionView.kID, for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell.init() // gonna have to revisit that
        }
        cell.bottomImageView.image = bottomCollection[indexPath.row]
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.borderColor = .gridyGold
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
extension BottomCollectionView: UICollectionViewDropDelegate {  // will add them to a new file
    
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
            
            if imageArray.first!.pngData() == self.correctImages[destIndexPath.row].pngData(){
            
                self.zScore += 5
                self.scoreDelegate.updateScore(score: self.zScore)
                self.bottomCollection.remove(at: destIndexPath.row)
                self.bottomCollection.insert(imageArray.first!, at: destIndexPath.row)
                collectionView.insertItems(at: [destIndexPath])
                print("performed")
                print(self.zScore)
            } else {
                print("couldnt perform")
                self.zScore -= 3.5
                self.scoreDelegate.updateScore(score: self.zScore)
                print(self.zScore)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,   dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
}
