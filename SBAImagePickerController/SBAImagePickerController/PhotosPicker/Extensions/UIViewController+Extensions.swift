//
//  UIViewController+Extensions.swift
//  SBAImagePickerController
//
//  Created by Shoaib Akhtar on 05/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import UIKit
extension UIViewController{
    func addRightBarButton(title: String? = nil, target: Any? = nil,selector: Selector? = nil){
        if let sel = selector {
            let button = UIBarButtonItem.init(title: title, style: UIBarButtonItem.Style.plain, target: target, action: sel)
            self.navigationItem.rightBarButtonItem = button
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarButtonAction))
        }
    }

    @objc func rightBarButtonAction() {
        
    }

}

extension UIViewController {
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
