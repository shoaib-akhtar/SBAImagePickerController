//
//  StoryboardInitializable.swift
//  MyStuff
//
//  Created by MHS on 10/05/2018.
//  Copyright © 2018 QuantumCPH. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
    static func storyboardName() -> String
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName(), bundle: SBABundle.appBundle())
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
