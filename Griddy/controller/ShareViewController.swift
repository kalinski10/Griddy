//
//  ShareViewController.swift
//  Griddy
//
//  Created by Kalin Balabanov on 27/05/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    var textRecieved: String?
    var completedImageRecieved: UIImage?
    var scoreRecieved: String?
    
    @IBOutlet weak var puzzleImage: UIImageView!
    @IBOutlet weak var scoreText: UITextView!
    
    @IBAction func shareButton(_ sender: Any) {
        displaySharingOptions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        scoreText.backgroundColor = .white
        puzzleImage.image = completedImageRecieved
        scoreText.text = textRecieved
        puzzleImage.layer.cornerRadius = puzzleImage.bounds.height / 8
        puzzleImage.contentMode = .scaleAspectFill
    }
    
    func displaySharingOptions() {
        
        let name = String(format: Constants.String.sharingScore, scoreRecieved ?? "unknown")
        let image = completedImageRecieved
        let items = [name as Any, image as Any]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        present(activityController, animated: true, completion: .none)
    }
    
}
