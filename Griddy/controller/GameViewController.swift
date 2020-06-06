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
    var hiddenImage: UIImage?
    let topLayout = UICollectionViewFlowLayout()
    let bottomLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var topCollectionView: TopCollectionView!
    @IBOutlet weak var bottomCollectionView: BottomCollectionView!
    @IBOutlet weak var dragText: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWhiteImages()
        topCollectionView.shuffledImages = sliceImageArray.shuffled()
        bottomCollectionView.plainImages = whiteImageArray
        bottomCollectionView.correctImages = sliceImageArray
        setup()
        bottomCollectionView.scoreDelegate = self
        bottomCollectionView.correctMovesDelegate = self
    }
    
    func addWhiteImages() {
        for _ in 1 ... 16 {
            whiteImageArray.append(#imageLiteral(resourceName: "whiteImages"))
        }
    }
    
    private func setup() {
        
        self.view.backgroundColor = .white
        score.text = "0"
        
        let topItemSize = topCollectionView.bounds.width/6 - 5
        let bottomItemSize = bottomCollectionView.bounds.width/4
        
        topLayout.itemSize = CGSize(width: topItemSize, height: topItemSize)
        topLayout.minimumLineSpacing = 5
        topLayout.minimumInteritemSpacing = 5
        topLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        bottomLayout.itemSize = CGSize(width: bottomItemSize, height: bottomItemSize)
        bottomLayout.minimumLineSpacing = 0
        bottomLayout.minimumInteritemSpacing = 0
        bottomLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        topCollectionView.collectionViewLayout = topLayout
        topCollectionView.backgroundColor = .white
        topCollectionView.isScrollEnabled = false
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomCollectionView.collectionViewLayout = bottomLayout
        bottomCollectionView.backgroundColor = .white
        bottomCollectionView.isScrollEnabled = false
        bottomCollectionView.layer.borderColor = .gridyGold
        bottomCollectionView.layer.borderWidth = CGFloat(2)
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareSegue" {
            
            let vc = segue.destination as! ShareViewController
            vc.textRecieved = "Game over, congratulations! Your score is \(score.text!).\nShare this with you friends!"
            vc.scoreRecieved = score.text
            vc.completedImageRecieved = hiddenImage
        }
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

extension GameViewController: TrackCorrectMovementsDelegate {
    func numberOfCorrectMoves(moves: Int) {
        if moves == 16 { // currently its at 1 for testing // gonna chnage to 16
            performSegue(withIdentifier: "shareSegue", sender: self)
        }
    }
}
