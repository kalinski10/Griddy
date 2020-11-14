//
//  ViewController.swift
//  Griddy
//
//  Created by Kalin Balabanov on 14/11/2019.
//  Copyright © 2019 Kalin Balabanov. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private var localImages = [UIImage]()
    public var imageToPass: UIImage!
    private var currentImageIndex = -1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        collectImageSet()
    }
    
    @IBAction func helpButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.helpVC, sender: self)
    }
    
    @IBAction func mainUnwind(unwindSegue: UIStoryboardSegue) { }
    
    @IBAction func griddyPickButton(_ sender: UIButton) {
        randomImage()
        performSegue(withIdentifier: Constants.Segue.sliceVC, sender: self)
    }
    
    @IBAction func CameraButton(_ sender: UIButton) {
        displayCamera()
    }
    
    @IBAction func photoLibraryButton(_ sender: UIButton) {
        displayLibrary()
    }
    
    private func displayLibrary() {
        
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({(granted) in
                    DispatchQueue.main.async {
                        if granted == .authorized {
                            self.presentImagePicker(sourceType: sourceType)
                        } else {
                            self.alertMessage(message: Constants.String.NoPermissionMessage.photoLibrary)
                        }
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                alertMessage(message: Constants.String.NoPermissionMessage.photoLibrary)
            case .limited:
                alertMessage(message: Constants.String.NoPermissionMessage.limited)
            @unknown default:
                fatalError()
            }
        } else {
            self.alertMessage(message: Constants.String.CantAccess.photoLibrary )
        }
    }
    
    private func displayCamera() {
        
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {(granted) in
                    DispatchQueue.main.async {
                        if granted {
                            self.presentImagePicker(sourceType: sourceType)
                        } else { self.alertMessage(message: Constants.String.NoPermissionMessage.camera)}
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .restricted, .denied:
                self.alertMessage(message: Constants.String.NoPermissionMessage.camera)
            @unknown default:
                fatalError()
            }
        } else {
            self.alertMessage(message: Constants.String.CantAccess.camera)
        }
    }
    
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let tempImg = info [UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageToPass = tempImg
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: Constants.Segue.sliceVC, sender: self)
        }
    }
    
    private func alertMessage(message: String?){
        
        let alertController = UIAlertController(title: Constants.String.Title.alertController, message: message, preferredStyle: .alert)
        let OKaction = UIAlertAction(title: Constants.String.Title.alertAction , style: .cancel)
        alertController.addAction(OKaction)
        present(alertController, animated: true)
    }
    
    private func collectImageSet() { //collecing all the integrated images
        
        localImages.removeAll()
        let imageNames = [Constants.Image.Puzzle.cat, Constants.Image.Puzzle.dog, Constants.Image.Puzzle.umbrella, Constants.Image.Puzzle.bike, Constants.Image.Puzzle.nature]
        
        for image in imageNames {
                localImages.append(image)
        }
        
    }
     
    private func randomImage() {
        
        var randIndex: Int
        repeat { // repeating until idex is different, so that the rand image will different each time
            randIndex = Int.random(in: 0..<localImages.count)
        } while currentImageIndex == randIndex
        
        imageToPass = localImages[randIndex]
        currentImageIndex = randIndex
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.sliceVC {
            guard let vc = segue.destination as? SliceViewController else {
               print("could not find SliceViewController")
                return
            }
            vc.imageRecieved = imageToPass
        }
    }
    
}


