//
//  ViewController.swift
//  SBAImagePickerController
//
//  Created by Shoaib Akhtar on 05/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import UIKit
import SBAImagePickerController
class ViewController: UIViewController {

    @IBOutlet weak var first: UIButton!
    @IBOutlet weak var second: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        first.titleLabel?.isOpaque = true
        first.titleLabel?.backgroundColor = .white
        
        second.titleLabel?.isOpaque = true
        second.titleLabel?.backgroundColor = .white
    }

    @IBAction func push(_ sender: Any) {
        let coordinator = SBAMultipleImagePickerController.init(rootViewCOntroler: self,maximumImages: 5) { (images, cancel) in
            print(images?.count ?? 0)
        }
        coordinator.push()
    }
    
    @IBAction func present(_ sender: Any) {
<<<<<<< HEAD
        let coordinator = SBAMultipleImagePickerController.init(rootViewCOntroler: self,maximumImages: 5) { (images, cancel) in
=======
        let coordinator = MultiplePhotosPickerCoordinator.init(rootViewCOntroler: self,maximumImages: 30) { (images, cancel) in
>>>>>>> jwd
            print(images?.count ?? 0)
        }
        coordinator.present()
    }
    
}


