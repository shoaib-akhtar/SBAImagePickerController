//
//  ViewController.swift
//  SBAImagePickerController
//
//  Created by Shoaib Akhtar on 05/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func open(_ sender: Any) {
        let coordinator = MultiplePhotosPickerCoordinator.init(rootViewCOntroler: self,maximumImages: 5) { (image, cancel) in
            print(image?.count ?? 0)
        }
        coordinator.start()
    }
    
}

