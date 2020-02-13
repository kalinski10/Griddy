//
//  TopCollectionView.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/01/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

class TopCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public var topCollection = [UIImage]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        dataSource = self
        delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "topCollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.topImageView.image = topCollection[indexPath.row]
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
