//
//  viewControllerThree.swift
//  Griddy
//
//  Created by Kalin Balabanov on 12/12/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class viewControllerThree: ViewController /*UICollectionViewDataSource, UICollectionViewDelegate*/ {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliceImageArray.shuffle()
        collectionOne = sliceImageArray
        collectionTwo = sliceImageArray
        tempImageView.image = collectionOne[1]
    }
    
    var sliceImageArray = [UIImage]()
    var collectionOne = [UIImage]()
    var collectionTwo = [UIImage]()
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliceImageArray.count + 2
    }
    
}
