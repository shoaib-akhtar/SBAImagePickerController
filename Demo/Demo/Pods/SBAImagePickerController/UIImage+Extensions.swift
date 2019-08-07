//
//  UIImage+Extensions.swift
//  SBAImagePickerController
//
//  Created by Shoaib Akhtar on 07/08/2019.
//

import UIKit
extension UIImage{
    static func bundleImage(named: String) -> UIImage? {
        let image = UIImage.init(named: named, in: SBABundle.appBundle(), compatibleWith: nil)
        return image
    }
}
