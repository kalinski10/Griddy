//
//  Enums.swift
//  Griddy
//
//  Created by Kalin Balabanov on 28/06/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

enum Constants {
    
    enum String {
        
        enum NoPermissionMessage {
            
            static  let photoLibrary = "Looks like Gridy doesn't have access to your photos :( please use settings app on your device to permit Gridy accessing your library"
            
            static let camera = "Looks like Gridy doesn't have access to your camera :( please use settings app on your device to permit Gridy accessing your camera"
        }
        
        enum CantAccess {
            
            static let photoLibrary = "Sincere apologies, it looks like we can't access your photo library at this time"
            
            static let camera = "Sincere apologies, it looks like we can't access your camera at this time"
            
        }
        
        enum Title {
            
            static let alertController = "Oops..."
            static let alertAction = "Got it"
            
        }
        
        static let gameOverText = "Game over, congratulations! Your score is %@.\nShare this with you friends!"
        
        static let sharingScore = "Griddy \nMy score is %@! Can you beat it?"
    }
    
    
    enum Image {
        
        static let white = #imageLiteral(resourceName: "whiteImages")
        static let eye = #imageLiteral(resourceName: "eye")
        
        enum Puzzle {
            static let cat = #imageLiteral(resourceName: "cat")
            static let dog = #imageLiteral(resourceName: "dog")
            static let umbrella = #imageLiteral(resourceName: "umbrellas")
            static let bike = #imageLiteral(resourceName: "motorBike")
            static let nature = #imageLiteral(resourceName: "nature")
        }
    }
    
    enum Segue {
        static let sliceVC = "segue"
        static let gameVC = "segueTwo"
        static let shareVC = "shareSegue"
        static let helpVC = "segueToHelp"
    }
    
}
