//
//  viewControllerThree.swift
//  Griddy
//
//  Created by Kalin Balabanov on 12/12/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class viewControllerThree: ViewController {

    public var sliceImageArray = [UIImage]()
    
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var topCollectionView: TopCollectionView!
    @IBOutlet weak var bottomCollectionView: BottomCollectionView!
    @IBOutlet weak var dragText: UIImageView!
    
    @IBAction func newGameButton(_ sender: Any) {
        performSegue(withIdentifier: "segueThree", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topCollectionView.topCollection = sliceImageArray.shuffled()
        bottomCollectionView.bottomCollection = sliceImageArray

        setup()

    }
    
    private func setup() {
        
        let topItemSize = topCollectionView.bounds.width/6 - 5
        let bottomItemSize = bottomCollectionView.bounds.width/4
        
        let TopLayout = UICollectionViewFlowLayout()
        TopLayout.itemSize = CGSize(width: topItemSize, height: topItemSize)
        TopLayout.minimumLineSpacing = 5
        TopLayout.minimumInteritemSpacing = 5
        
        let bottomLayout = UICollectionViewFlowLayout()
        bottomLayout.itemSize = CGSize(width: bottomItemSize, height: bottomItemSize)
        bottomLayout.minimumLineSpacing = 0
        bottomLayout.minimumInteritemSpacing = 0
       
        
        topCollectionView.collectionViewLayout = TopLayout
        bottomCollectionView.collectionViewLayout = bottomLayout
        self.view.backgroundColor = .white
        topCollectionView.backgroundColor = .white
        bottomCollectionView.backgroundColor = .white
        bottomCollectionView.isScrollEnabled = false
        topCollectionView.isScrollEnabled = false
//
//
//        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        bottomCollectionView.heightAnchor.constraint(equalTo: bottomCollectionView.widthAnchor).isActive = true
//
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueThree" {
            _ = segue.destination as! ViewController
        }
    }
    
}
