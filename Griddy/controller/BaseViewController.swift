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
            let noPermissionMessage = "Looks like Gridy doesn't have access to your photos :( please use settings app on your device to permit Gridy accessing your library"
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({(granted) in
                    DispatchQueue.main.async {
                        if granted == .authorized {
                            self.presentImagePicker(sourceType: sourceType)
                        } else {
                            self.alertMessage(message: noPermissionMessage)
                        }
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                alertMessage(message: noPermissionMessage)
            @unknown default:
                fatalError()
            }
        } else {
            self.alertMessage(message: "Sincere apologies, it looks like we can't access your photo library at this time")
        }
    }
    
    private func displayCamera() {
        
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            let noPermissionMessage = "Looks like Gridy doesn't have access to your camera :( please use settings app on your device to permit Gridy accessing your camera"
            
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {(granted) in
                    DispatchQueue.main.async {
                        if granted {
                            self.presentImagePicker(sourceType: sourceType)
                        } else { self.alertMessage(message: noPermissionMessage)}
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .restricted, .denied:
                self.alertMessage(message: noPermissionMessage)
            @unknown default:
                fatalError()
            }
        } else {
            self.alertMessage(message: "Sincere apologies, it looks like we can't access your camera at this time")
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
        
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKaction = UIAlertAction(title: "Got it", style: .cancel)
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


