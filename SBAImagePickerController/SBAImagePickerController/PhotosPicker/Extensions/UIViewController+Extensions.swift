//
//  UIViewController+Extensions.swift
//  SBAImagePickerController
//
//  Created by Shoaib Akhtar on 05/08/2019.
//  Copyright © 2019 ShoaibAkhtar. All rights reserved.
//

import UIKit
enum SBButtonTappedType {
    case cancel
    case action
    
}
// Bar Button Handling
extension UIViewController{
    func addRightBarButton(title: String? = nil, image: UIImage? = nil, target: Any? = nil,selector: Selector? = nil){
        if let sel = selector {
            let button = barButton(title: title, image: image, target: target, selector: sel)
            self.navigationItem.rightBarButtonItem = button
        }else{
            let button = barButton(title: title, image: image, target: self, selector: #selector(rightBarButtonAction))
            self.navigationItem.rightBarButtonItem = button
        }
    }
    
    func addLeftBarButton(title: String? = nil, image: UIImage? = nil, target: Any? = nil,selector: Selector? = nil){
        self.navigationItem.leftBarButtonItem = selectorSetup(title: title, image: image, target: target, selector: selector)
    }
    
    private func selectorSetup(title: String? = nil, image: UIImage? = nil, target: Any? = nil,selector: Selector? = nil) -> UIBarButtonItem{
        if let sel = selector, let tar = target {
            return barButton(title: title, image: image, target: tar, selector: sel)
        }else{
            return barButton(title: title, image: image, target: self, selector: #selector(leftBarButtonAction))
        }
    }
    
    func addBackButton()  {
        let barButton = selectorSetup(title: nil, image: UIImage(named: "hbNavBack"), target: nil, selector: nil)
        barButton.imageInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func makeBarButtonVisible(barButton: UIBarButtonItem) {
        barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)
    }
    
    private func barButton(title: String?, image: UIImage?, target: Any?,selector: Selector?) -> UIBarButtonItem{
        var barButtonItem: UIBarButtonItem
        
        if title != nil, image != nil {
            let addButton = UIButton(type: .system)
            addButton.setImage(image, for: .normal)
            addButton.setTitle(" " + title!, for: .normal)
            addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            addButton.sizeToFit()
            addButton.addTarget(self, action: selector!, for: .touchUpInside)
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: addButton.frame.size.width + 15, height: addButton.frame.size.height + 10))
            view.backgroundColor = UIColor.black
            view.layer.cornerRadius = view.frame.size.height / 2.0
            addButton.center = view.center
            view.addSubview(addButton)
            
            barButtonItem = UIBarButtonItem(customView: view)
        } else if title != nil {
            barButtonItem = UIBarButtonItem(title: title!, style: .plain, target: target, action: selector)
            barButtonItem.tintColor = .white
            makeBarButtonVisible(barButton: barButtonItem)
        } else if image != nil {
            barButtonItem = UIBarButtonItem(image: image, style: .plain, target: target, action: selector)
            barButtonItem.tintColor = .white
            
        } else {
            barButtonItem = UIBarButtonItem()
        }
        return barButtonItem
    }
    
    @objc func rightBarButtonAction() {
        
    }
    @objc func leftBarButtonAction() {
        
    }
    
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
    
    func showError (title : String , message: String ,  actionTitle: String ,completion:@escaping(SBButtonTappedType)-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
             completion(.cancel)
        }))
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.destructive, handler: { action in
            completion(.action)
        }))
        self.present(alert, animated: true, completion:nil)
    }
}
