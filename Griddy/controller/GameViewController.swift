//
//  viewControllerThree.swift
//  Griddy
//
//  Created by Kalin Balabanov on 12/12/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    public var sliceImageArray = [UIImage]()
    public var whiteImageArray = [UIImage]()

    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var topCollectionView: TopCollectionView!
    @IBOutlet weak var bottomCollectionView: BottomCollectionView!
    @IBOutlet weak var dragText: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWhiteImages()
        topCollectionView.topCollection = sliceImageArray.shuffled()
        bottomCollectionView.bottomCollection = whiteImageArray
        bottomCollectionView.correctImages = sliceImageArray
        setup()
        bottomCollectionView.scoreDelegate = self
    }
    
    func addWhiteImages() {
        for _ in 1 ... 16 {
            whiteImageArray.append(#imageLiteral(resourceName: "whiteImages"))
        }
    }
    
    private func setup() {
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        score.text = String(Int(bottomCollectionView.zScore))

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
       
        self.view.backgroundColor = .white
        topCollectionView.collectionViewLayout = TopLayout
        topCollectionView.backgroundColor = .white
        topCollectionView.isScrollEnabled = false
        
        bottomCollectionView.collectionViewLayout = bottomLayout
        bottomCollectionView.backgroundColor = .white
        bottomCollectionView.isScrollEnabled = false
        bottomCollectionView.layer.borderColor = .gridyGold
        bottomCollectionView.layer.borderWidth = CGFloat(2)
    }
}

extension CGColor {
    static var gridyGold: CGColor {
        return CGColor(srgbRed: 212/255, green: 175/255, blue: 55/255, alpha: 1)
    }
}

extension GameViewController: UpdateScoreDelegate {
    func updateScore(score: Double) {
        self.score.text = String(Int(score))
    }
}
