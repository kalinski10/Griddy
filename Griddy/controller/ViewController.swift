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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var localImages = [UIImage].init()
    var imageToPass: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectImageSet()
    }
    
    @IBAction func griddyPickButton(_ sender: UIButton) {
        randomImage()
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBAction func CameraButton(_ sender: UIButton) {
        displayMedia(x: .camera, y: "Camera")
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBAction func photoLibraryButton(_ sender: UIButton) {
        displayLibrary()
        performSegue(withIdentifier: "segue", sender: self)
    }
   func displayLibrary() {
       let sourceType = UIImagePickerController.SourceType.photoLibrary
       if UIImagePickerController.isSourceTypeAvailable(sourceType) {
           let status = PHPhotoLibrary.authorizationStatus()
           let noPermissionMessage = "Looks like FrameIT doesn't have access to your photos :( please use settings app on your device to permit FrameIT accessing your library"
           
           switch status {
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization({(granted) in
                   if granted == .authorized {
                       self.presentImagePicker(sourceType: sourceType)
                   }else {
                       self.alertMessage(message: noPermissionMessage)
                   }
               })
           case .authorized:
               self.presentImagePicker(sourceType: sourceType)
           case .restricted, .denied:
               self.alertMessage(message: noPermissionMessage)
           @unknown default:
               print("error")
           }
       } else {
           alertMessage(message: "Sincere apologies, it looks like we can't access your photo library at this time")
       }
   }
    func displayMedia(x: UIImagePickerController.SourceType, y: String) {
        
        let sourceType = x
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Looks like Griddy doesn't have access to your photos:( Please use Setting app on your device to permit Griddy accessing your \(y)"
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:{(granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.alertMessage(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.alertMessage(message: noPermissionMessage)
            @unknown default:
                print("error")
            }
        } else {
            alertMessage(message: "Sincere apologies, it looks like we cant access your \(y) at this time!")
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func alertMessage(message: String?){
        let alertController = UIAlertController(title: "Oops...", message: message, preferredStyle: .alert)
        let OKaction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKaction)
        present(alertController, animated: true)
    }
    
    func collectImageSet() { //collecing all the integrated images
        localImages.removeAll()
        let imageNames = ["cat", "dog", "umbrellas", "cake", "motorBike"]
        
        for name in imageNames {
            if let image = UIImage.init(named: name){
                localImages.append(image)
            }
        }
    }
    
    func randomImage() { //choosing a random picture
        let randIndex = Int.random(in: 0..<localImages.count)
        imageToPass = localImages[randIndex]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ViewControllerTwo
            vc.imageRecieved = imageToPass
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let tempImg = info [UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageToPass = tempImg
    }
}
