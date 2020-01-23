//
//  viewControllerThree.swift
//  Griddy
//
//  Created by Kalin Balabanov on 12/12/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class viewControllerThree: ViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionOne = sliceImageArray
        collectionTwo = sliceImageArray
        sliceImageArray.shuffle()
    }
    
    var sliceImageArray = [UIImage]()
    var collectionOne = [UIImage]()
    var collectionTwo = [UIImage]()
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliceImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCollectionViewCell", for: indexPath) as! topCollectionViewCell
        cell.topImageView.image = collectionOne[0]
            return cell
     }
    
    
    
}
