//
//  Enums.swift
//  Griddy
//
//  Created by Kalin Balabanov on 28/06/2020.
//  Copyright © 2020 Kalin Balabanov. All rights reserved.
//

import UIKit

enum Constants {
    
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
    }
    
}
