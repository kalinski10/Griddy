//
//  BottomCollectionView.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/01/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit
import AVFoundation

// will add all protocols to new files
protocol UpdateScoreDelegate {
    func updateScore(score: Double)
}

protocol TrackCorrectMovementsDelegate {
    func numberOfCorrectMoves(moves: Int)
}

class BottomCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var scoreDelegate: UpdateScoreDelegate!
    var correctMovesDelegate: TrackCorrectMovementsDelegate!
    public var plainImages = [UIImage]()
    public var correctImages = [UIImage]()
    private var zScore: Double = 30.0
    private var correctMoves: Int = 0
    private static let kID = "bottomCollectioViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        dataSource = self
        dropDelegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plainImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: BottomCollectionView.kID, for: indexPath) as? CollectionViewCell else { return CollectionViewCell.init() }
        cell.bottomImageView.image = plainImages[indexPath.row]
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.borderColor = .gridyGold
        let width = frame.size.width / 4
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        return cell
    }
    
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
                self.correctMoves += 1
                self.correctMovesDelegate.numberOfCorrectMoves(moves: self.correctMoves)
                self.plainImages.remove(at: destIndexPath.row)
                self.plainImages.insert(imageArray.first!, at: destIndexPath.row)
                collectionView.insertItems(at: [destIndexPath])
                print("performed")
                print(self.zScore)
            } else {
                print("couldnt perform")
                self.zScore -= 3.5
                self.scoreDelegate.updateScore(score: self.zScore)
                print(self.zScore)
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,   dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
}
