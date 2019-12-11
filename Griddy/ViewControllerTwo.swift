//
//  ViewControllerTwo.swift
//  Griddy
//
//  Created by Kalin Balabanov on 19/11/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit

class ViewControllerTwo: UIViewController, UIGestureRecognizerDelegate {

    var imageRecieved: UIImage?
    
    @IBOutlet weak var creationImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var sliceImageView: UIView!
    
    var initialImageViewOffset = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        creationImage.image = imageRecieved
        backImage.image = imageRecieved
        configure()
    }
    
    @IBAction func exitButton(_ sender: Any) {
        
        print("need to exit")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        
        print("slice and dice")
        print("prepare for segue")
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
