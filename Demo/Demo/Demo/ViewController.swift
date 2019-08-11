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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func push(_ sender: Any) {
        let coordinator = PhotosPickerCoordinator.init(rootViewCOntroler: self) { (images, cancel) in
            print(images?.count ?? 0)
        }
        coordinator.push()
    }
    
    @IBAction func present(_ sender: Any) {
        let coordinator = MultiplePhotosPickerCoordinator.init(rootViewCOntroler: self,maximumImages: 3) { (images, cancel) in
            print(images?.count ?? 0)
        }
        coordinator.present()
    }
    
}

