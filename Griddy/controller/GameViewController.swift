//
//  viewControllerThree.swift
//  Griddy
//
//  Created by Kalin Balabanov on 12/12/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public var sliceImageArray = [UIImage]()
    public var whiteImageArray = [UIImage]()
    private var shuffledImages = [UIImage]()
    var hiddenImage: UIImage?
    let topLayout = UICollectionViewFlowLayout()
    let bottomLayout = UICollectionViewFlowLayout()
        
    private var zScore: Double = 30.0
    private var correctMoves: Int = 0
    
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    @IBOutlet weak var dragText: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWhiteImages()
        shuffledImages = sliceImageArray.shuffled()
        setup()
        setupLayouts()
        
    }
    
    private func setup() {
            
        hintImageView.image = hiddenImage
        hintImageView.layer.borderColor = .gridyGold
        hintImageView.layer.borderWidth = 2
        
        topCollectionView.isScrollEnabled = false
        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        topCollectionView.dragDelegate = self
        topCollectionView.dropDelegate = self
        topCollectionView.dragInteractionEnabled = true
        
        bottomCollectionView.isScrollEnabled = false
        bottomCollectionView.layer.borderColor = .gridyGold
        bottomCollectionView.layer.borderWidth = CGFloat(2)
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.dropDelegate = self
        
    }
    
    private func setupLayouts() {
        
        let bottomWidth = bottomCollectionView.bounds.width / 4
        let topWidth = topCollectionView.bounds.width / 6 - 5
        
        topLayout.minimumInteritemSpacing = 5
        topLayout.minimumLineSpacing = 5
        topLayout.itemSize = CGSize(width: topWidth, height: topWidth)
        
        bottomLayout.minimumInteritemSpacing = 0
        bottomLayout.minimumLineSpacing = 0
        bottomLayout.itemSize = CGSize(width: bottomWidth, height: bottomWidth)
        
        topCollectionView.collectionViewLayout = topLayout
        bottomCollectionView.collectionViewLayout = bottomLayout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == bottomCollectionView {
            return whiteImageArray.count
        }
        // + 2 for the additional cells
        return shuffledImages.count + 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topCollectionView {
            
//            let width = collectionView.bounds.width / 6 - 5
//            let layout = UICollectionViewFlowLayout()
//            layout.itemSize = CGSize(width: width, height: width)
            
            if indexPath.row < shuffledImages.count {
                
                guard let cell = topCollectionView.dequeueReusableCell(withReuseIdentifier: "topCollectionViewCell", for: indexPath) as? CollectionViewCell else { return CollectionViewCell() }
                cell.topImageView.image = shuffledImages[indexPath.row]
                cell.layer.borderWidth = CGFloat(2)
                cell.layer.borderColor = .gridyGold
                return cell
                
            } else if indexPath.row == shuffledImages.count {
                
                let emptyCell = topCollectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath)
                return emptyCell
                
            } else {
                
                let eyeCell = topCollectionView.dequeueReusableCell(withReuseIdentifier: "eyeCell", for: indexPath)
                eyeCell.isUserInteractionEnabled = true
                let eyeButton = UIButton()
                eyeCell.addSubview(eyeButton)
                eyeButton.translatesAutoresizingMaskIntoConstraints = false
                eyeButton.setImage(UIImage(named: "eye"), for: .normal)
                eyeButton.topAnchor.constraint(equalTo: eyeCell.topAnchor).isActive = true
                eyeButton.bottomAnchor.constraint(equalTo: eyeCell.bottomAnchor).isActive = true
                eyeButton.leadingAnchor.constraint(equalTo: eyeCell.leadingAnchor).isActive = true
                eyeButton.trailingAnchor.constraint(equalTo: eyeCell.trailingAnchor).isActive = true
                eyeButton.addTarget(self, action: #selector(self.eyeTapped), for: .touchUpInside)
                return eyeCell
                
            }
        } else {
            guard let bottomCell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: "bottomCollectioViewCell", for: indexPath) as? CollectionViewCell else { return CollectionViewCell.init() }
            bottomCell.bottomImageView.image = whiteImageArray[indexPath.row]
            bottomCell.layer.borderWidth = CGFloat(1)
            bottomCell.layer.borderColor = .gridyGold
//            let bottomWidth = collectionView.bounds.width / 4
//            let bottomLayout = UICollectionViewFlowLayout()
//            bottomLayout.itemSize = CGSize(width: bottomWidth, height: bottomWidth)
            return bottomCell
        }
    }
    
    @objc func eyeTapped() {
        
        hintImageView.isHidden = false
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideHintImage), userInfo: nil, repeats: false)
    }
    
    @objc func hideHintImage(){
        hintImageView.isHidden = true
    }
    
    // need to add function to invalidate layout // can find it on youtube
    
    
    
    func addWhiteImages() {
        for _ in 1 ... 16 {
            whiteImageArray.append(#imageLiteral(resourceName: "whiteImages"))
        }
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

// MARK: - DRAG DELEGATE EXTENSION

extension GameViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row < shuffledImages.count { // checks if its within the indexPath
            
            let item = shuffledImages[indexPath.row]
            let itemProvider = NSItemProvider(object: item as UIImage)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = dragItem
            if item.pngData() == whiteImageArray[1].pngData() { // checks if its a white image
                return []
            } else {
                return [dragItem]
            }
        }
        return[]
    }
    
}
// MARK: - DROP DELEGATE EXTENSION
extension GameViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if collectionView == bottomCollectionView {
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
                
                if imageArray.first!.pngData() == self.sliceImageArray[destIndexPath.row].pngData(){
                    
                    self.zScore += 5
                    self.score.text = String(Int(self.zScore))
                    self.correctMoves += 1
                    self.whiteImageArray.remove(at: destIndexPath.row)
                    self.whiteImageArray.insert(imageArray.first!, at: destIndexPath.row)
                    self.shuffledImages.remove(at: 2) //FIXME: need the index path of the drag item
                    self.shuffledImages.insert(UIImage.init(named: "whiteImages")!, at: 2)//FIXME: need the index path of the drag item
                    self.topCollectionView.reloadData()
                    collectionView.reloadData()
                    if self.correctMoves == 16 {
                        self.performSegue(withIdentifier: "shareSegue", sender: self)
                    }
                    
                } else {
                    self.zScore -= 3.5
                    self.score.text = String(Int(self.zScore))
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView == topCollectionView {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        }
    }
    
}

// MARK: - OTHER EXTENSIONS
extension CGColor {  // separate file // should add to enum // create as uicolour - better
    static var gridyGold: CGColor {
        return CGColor(srgbRed: 212/255, green: 175/255, blue: 55/255, alpha: 1)
    }
}
