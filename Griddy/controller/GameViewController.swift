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
    private let topLayout = UICollectionViewFlowLayout()
    private let bottomLayout = UICollectionViewFlowLayout()
    let sliceVC = SliceViewController()
    
    private var zScore: Double = 30.0
    private var correctMoves: Int = 0
    private var topCollectionIndexTracker = 0

    
    @IBOutlet weak var hintView: UIView!
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
        hintImageView.layer.borderColor = UIColor.gridyGold.cgColor
        hintImageView.layer.borderWidth = 2
        
        topCollectionView.isScrollEnabled = false
        topCollectionView.dataSource = self
        topCollectionView.delegate = self
        topCollectionView.dragDelegate = self
        topCollectionView.dropDelegate = self
        topCollectionView.dragInteractionEnabled = true
        
        bottomCollectionView.isScrollEnabled = false
        bottomCollectionView.layer.borderColor = UIColor.gridyGold.cgColor
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
        topCollectionView.reloadData()
        bottomCollectionView.reloadData()

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
            
            if indexPath.row < shuffledImages.count {
                
                guard let cell = topCollectionView.dequeueReusableCell(withReuseIdentifier: ID.topCell, for: indexPath) as? CollectionViewCell else {
                    print("could not find topCollection View Cells")
                    return CollectionViewCell()
                }
                cell.topImageView.image = shuffledImages[indexPath.row]
                cell.layer.borderWidth = CGFloat(2)
                cell.layer.borderColor = UIColor.gridyGold.cgColor
                return cell
                
            } else if indexPath.row == shuffledImages.count {
                
                let emptyCell = topCollectionView.dequeueReusableCell(withReuseIdentifier: ID.emptyCell, for: indexPath)
                return emptyCell
                
            } else {
                
                let eyeCell = topCollectionView.dequeueReusableCell(withReuseIdentifier: ID.eyeCell, for: indexPath)
                eyeCell.isUserInteractionEnabled = true
                if eyeCell.subviews.count == 1 { // checking if the eyeButton is already present
                    let eyeButton = UIButton()
                    eyeCell.addSubview(eyeButton)
                    eyeButton.translatesAutoresizingMaskIntoConstraints = false
                    eyeButton.setImage(Constants.Image.eye, for: .normal)
                    NSLayoutConstraint.activate([
                    eyeButton.topAnchor.constraint(equalTo: eyeCell.topAnchor),
                    eyeButton.bottomAnchor.constraint(equalTo: eyeCell.bottomAnchor),
                    eyeButton.leadingAnchor.constraint(equalTo: eyeCell.leadingAnchor),
                    eyeButton.trailingAnchor.constraint(equalTo: eyeCell.trailingAnchor) ])
                    eyeButton.addTarget(self, action: #selector(self.eyeTapped), for: .touchUpInside)
                }
                
                return eyeCell
            }
        } else {
            guard let bottomCell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: ID.bottomCell, for: indexPath) as? CollectionViewCell else {
                print("couldnt find bottomCollectionViewCell")
                return CollectionViewCell.init()
            }
            bottomCell.bottomImageView.image = whiteImageArray[indexPath.row]
            bottomCell.layer.borderWidth = CGFloat(1)
            bottomCell.layer.borderColor = UIColor.gridyGold.cgColor
            return bottomCell
        }
    }
    
    @objc func eyeTapped() {
        animateHintViewPopup()
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideHintImage), userInfo: nil, repeats: false)
    }
    
    @objc func hideHintImage(){

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .transitionFlipFromTop, animations: {
            self.hintView.transform = .init(translationX: 500, y: 500)
        }, completion: { (success) in
            self.hintView.isHidden = true
            self.hintView.transform = .identity
        })
    }
    
    func animateHintViewPopup() {
        UIView.transition(with: hintView, duration: 0.5, options: .transitionFlipFromBottom, animations: { self.hintView.isHidden = false}, completion: nil)
    }

    
    func addWhiteImages() {
        for _ in 1 ... 16 {
            whiteImageArray.append(#imageLiteral(resourceName: "whiteImages"))
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        topCollectionView.reloadData()
        bottomCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.shareVC {
            
            guard let vc = segue.destination as? ShareViewController else {
                print("could not find ShareViewController")
                return
            }
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
            
            topCollectionIndexTracker = indexPath.row
            let item = shuffledImages[indexPath.row]
            let itemProvider = NSItemProvider(object: item as UIImage)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = dragItem
            if item.pngData() == Constants.Image.white.pngData() { // checks if its a white image
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
                guard let imageArray = items as? [UIImage] else {
                    print("invalid Image Array")
                    return
                }
                
                if imageArray.first!.pngData() == self.sliceImageArray[destIndexPath.row].pngData(){
                    
                    self.zScore += 5
                    self.score.text = String(Int(self.zScore))
                    self.correctMoves += 1
                    self.whiteImageArray.remove(at: destIndexPath.row)
                    self.whiteImageArray.insert(imageArray.first!, at: destIndexPath.row)
                    self.shuffledImages.remove(at: self.topCollectionIndexTracker)
                    self.shuffledImages.insert(Constants.Image.white, at: self.topCollectionIndexTracker)
                    self.topCollectionView.reloadData()
                    collectionView.reloadData()
                    if self.correctMoves == 16 {
                        self.performSegue(withIdentifier: Constants.Segue.shareVC, sender: self)
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
//MARK: - FLOW LAYOUT DELEGATE

extension GameViewController: UICollectionViewDelegateFlowLayout {

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {

            let topWidth = topCollectionView.bounds.width / 6 - 5
            return CGSize(width: topWidth, height: topWidth)
        } else {

            let bottomWidth = bottomCollectionView.bounds.width / 4
            return CGSize(width: bottomWidth, height: bottomWidth)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topCollectionView {
            return 5
        } else {
            return 0
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == topCollectionView {
            return 5
        } else {
            return 0
        }
    }

}

// MARK: - CONSTANTS
private enum ID {

    static let topCell = "topCollectionViewCell"
    static let emptyCell = "emptyCell"
    static let eyeCell = "eyeCell"
    static let bottomCell = "bottomCollectioViewCell"
    
}
