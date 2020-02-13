//
//  viewControllerThree.swift
//  Griddy
//
//  Created by Kalin Balabanov on 12/12/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class viewControllerThree: ViewController {

    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var topCollectionView: TopCollectionView!
    @IBOutlet weak var bottomCollectionView: BottomCollectionView!
    
    public var sliceImageArray = [UIImage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        topCollectionView.topCollection = sliceImageArray.shuffled()
        
        let itemSize = topCollectionView.bounds.width/6 - 5
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        topCollectionView.collectionViewLayout = layout
    }
}
