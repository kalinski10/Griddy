//
//  ViewControllerTwo.swift
//  Griddy
//
//  Created by Kalin Balabanov on 19/11/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class SliceViewController: UIViewController, UIGestureRecognizerDelegate {

    var imageRecieved: UIImage?
    var toSend = [UIImage]()
    
    @IBOutlet weak var creationImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var sliceImageView: UIView!
    @IBOutlet weak var sliceTemp: UIImageView!
    
    var initialImageViewOffset = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sliceImageView.backgroundColor = .white
        creationImage.image = imageRecieved
        backImage.image = imageRecieved
        configure()
    }
    
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startButton(_ sender: Any) {
        imageRecieved = composeScreenShot()
        if let image = imageRecieved {
            DispatchQueue.global(qos: .userInitiated).async {
                // get cropped image
                self.toSend = self.slice(image: image, into: 4)
            }
        } else {
            print("Image not found")
        }
        performSegue(withIdentifier: "segueTwo", sender: self)
    }
    
    func composeScreenShot() -> UIImage {
        
        sliceTemp.isHidden = true
        UIGraphicsBeginImageContextWithOptions(sliceImageView.bounds.size, false, 0)
        sliceImageView.drawHierarchy(in: sliceImageView.bounds, afterScreenUpdates: true)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()!
        
        return screenShot
        
    }
    
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCGImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCGImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    func configure() {
    let moveGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImage(_:)))
    let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImage(_:)))
    let scaleGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage(_:)))
    creationImage.addGestureRecognizer(moveGestureRecognizer)
    creationImage.addGestureRecognizer(rotateGestureRecognizer)
    creationImage.addGestureRecognizer(scaleGestureRecognizer)
    moveGestureRecognizer.delegate = self
    rotateGestureRecognizer.delegate = self
    scaleGestureRecognizer.delegate = self
    }
    
    @objc func moveImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: creationImage.superview)
                 
        if sender.state == .began {
            initialImageViewOffset = creationImage.frame.origin
        }
                 
        let position = CGPoint(x: translation.x + initialImageViewOffset.x - creationImage.frame.origin.x, y: translation.y + initialImageViewOffset.y - creationImage.frame.origin.y)
                 
        creationImage.transform = creationImage.transform.translatedBy(x: position.x, y: position.y)
    }
    
    @objc func rotateImage(_ sender: UIRotationGestureRecognizer) {
        creationImage.transform = creationImage.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @objc func scaleImage(_ sender: UIPinchGestureRecognizer) {
        creationImage.transform = creationImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.view != creationImage {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTwo" {
            let vc = segue.destination as! GameViewController
            vc.sliceImageArray = toSend
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
